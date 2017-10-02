//
//  SHMTableViewForceTouchHandler.swift
//  Pods
//
//  Created by Dominik Bucher on 18/07/2017.
//
//

import Foundation
import UIKit

/// SHMTableViewForceTouchHandler is class that handles 3DTouch events for you.
/// It consists of dependencies and 2 closures - didPeek and didPop.
///
/// ## Example of usage
/// 
/// 1) Create instance
///
/// ````
/// let handler = SHMTableViewForceTouchHandler(
///     viewController: viewController,
///     tableView: tableView
/// )
/// ````
///
/// 2) Setup `didPeek` abd `didPop` closures.
///
/// ````
/// handler?.didPeek = { (indexPath) in
///
///     guard  let model = self.findModel(indexPath: indexPath),
///           let previewVC = self.storyboard?.instantiateViewController(withIdentifier: "AnyViewController") as? AnyViewController
///     else { return nil }
///
///     previewVC.property = self.property
///
///     return previewVC
/// }
///
/// handler?.didPop = { viewController in
///     self.navigationController?.pushViewController(viewController, animated: true)
/// }
/// ````
///
/// 3) In view controller's viewDidLoad call `register()` method for receiving force touch events
///
/// ````
/// override open func viewDidLoad()
/// {
///     super.viewDidLoad()
///
///     handler?.register()
/// }
/// ````
///
public class SHMTableViewForceTouchHandler: NSObject {
    /// Parent controller on which we are registring the 3DTouch actions
    public weak var parentViewController: UIViewController?
        
    /// UITableView for getting cells indexPaths
    public weak var tableView: UITableView?
    
    /// Custom closure determining action on peeking event
    public var didPeek: ((IndexPath) -> UIViewController?)?
    
    /// Closure determining pop (the hard force touch) when peeking
    public var didPop: ((UIViewController) -> Void)?
    
    public init(parentViewController: UIViewController?, tableView: UITableView?) {
        self.parentViewController = parentViewController
        self.tableView = tableView
    }
    
    /// Fuction that registers viewController from dependencies for receiving 3DTouch events
   public func register() {
        guard let view = parentViewController?.view else { return }
    
        parentViewController?.registerForPreviewing(with: self, sourceView: view)
    }
}

extension SHMTableViewForceTouchHandler: UIViewControllerPreviewingDelegate {
    /// Find the indexPath of cell according to position of touch, when found, cast the cell to Custom Cell and take label
    /// from it and carry it to viewController we wanna present. Then, return the viewController to present with given label.
    /// The label mustn't be set directly, because we instantiate it later, so the app would crash, so we set String attribute
    /// And in viewDidLoad we set this attribute to the label, where it already is instantiated...
    ///
    /// - Parameters:
    ///   - previewingContext: previewing context on this viewController
    ///   - location: location of touch in superview
    /// - Returns: ViewController to peak
    public func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard   let cellPostion = tableView?.convert(location, from: parentViewController?.view),
                let indexPath = tableView?.indexPathForRow(at: cellPostion)
        else { return nil }
        
        if let tableView = tableView {
            let cellRect = tableView.rectForRow(at: indexPath)
            let sourceRect = previewingContext.sourceView.convert(cellRect, from: tableView)
            previewingContext.sourceRect = sourceRect
        }
        
        return didPeek?(indexPath)
    }
    
    /// This is action to occur on force taping the display. Instead of this, you can implement your custom action,
    /// not just push or show the previewed viewController
    ///
    /// - Parameters:
    ///   - previewingContext: previewing context on this viewController
    ///   - viewControllerToCommit: the viewController received from peaking so no need to instantiate it again...
    public func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        didPop?(viewControllerToCommit)
    }
}
