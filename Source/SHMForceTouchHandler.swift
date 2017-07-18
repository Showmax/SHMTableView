//
//  SHMForceTouchHandler.swift
//  Pods
//
//  Created by Dominik Bucher on 18/07/2017.
//
//

import Foundation
import UIKit

/**
 SHMForceTouchHandler is class that easily handles 3DTouch events for you.
 It consists of dependencies and 2 closures - didPeek and didPop.
 
 To use this feature, simply 
 
 
 */
public class SHMForceTouchHandler: NSObject
{
    
    /// Dependencies of our ForceTouchHandler,
    /// 
    public struct ForceTouchDependencies
    {
        public weak var parentViewController: UIViewController?
        
        /// SHMTableView for getting cells indexPaths
        public var shmTableView: SHMTableView?
    }
    
    
    /// Dependencies 
    public var dependencies: ForceTouchDependencies
    
    
    
    /// Custom closure determining action on peeking event
    public var didPeek: ((IndexPath, Any?) -> UIViewController?)?
    
    /// Closure determining pop (the hard force touch) when peeking
    public var didPop: ((UIViewController) -> Void)?
    
    public init(dependencies: ForceTouchDependencies)
    {
        self.dependencies = dependencies
    }
    
    /// Fuction that registers viewController from dependencies for receiving 3DTouch events
   public func register()
    {
        guard let view = dependencies.parentViewController?.view else { return }
    
        dependencies.parentViewController?.registerForPreviewing(with: self, sourceView: view)
    }
}

extension SHMForceTouchHandler: UIViewControllerPreviewingDelegate
{

    /// Find the indexPath of cell according to position of touch, when found, cast the cell to Custom Cell and take label
    /// from it and carry it to viewController we wanna present. Then, return the viewController to present with given label.
    /// The label mustn't be set directly, because we instantiate it later, so the app would crash, so we set String attribute
    /// And in viewDidLoad we set this attribute to the label, where it already is instantiated...
    ///
    ///
    /// - Parameters:
    ///   - previewingContext: previewing context on this viewController
    ///   - location: location of touch in superview
    /// - Returns: ViewController to peak
    public func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? 
    {
        guard   let cellPostion = dependencies.shmTableView?.tableView?.convert(location, from: dependencies.parentViewController?.view),
                let  indexPath = dependencies.shmTableView?.tableView?.indexPathForRow(at: cellPostion) 
        else 
        {
            return nil 
        }
        
        if let tableView = dependencies.shmTableView?.tableView
        {
            let cellRect = tableView.rectForRow(at: indexPath)
            let sourceRect = previewingContext.sourceView.convert(cellRect, from: tableView)
    
            previewingContext.sourceRect = sourceRect
        }
        
        if let section = dependencies.shmTableView?.sections[indexPath.section]
        {
        
        let row = section.rows[indexPath.row] 
            
        }
        
        
            let model: Any? = nil // search shmtable view for model for corresponding indexpath  
        
        return didPeek?(indexPath, model)
        
    }
    
    
    /// This is action to occur on force taping the display. Instead of this, you can implement your custom action,
    /// not just push or show the previewed viewController
    ///
    /// - Parameters:
    ///   - previewingContext: previewing context on this viewController
    ///   - viewControllerToCommit: the viewController received from peaking so no need to instantiate it again...
    public func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController)
    {
        didPop?(viewControllerToCommit)
        
    }
}
