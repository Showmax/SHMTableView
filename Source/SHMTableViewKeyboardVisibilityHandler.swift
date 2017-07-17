//
//  SHMTableViewKeyboardVisibilityHandler.swift
//  Pods
//
//  Created by Dominik Bucher on 14/07/2017.
//
//

import Foundation
import UIKit

// swiftlint:disable trailing_whitespace

public protocol SHMScrollingDelegate: class
{

func setActive(indexPath: IndexPath)

}


public class SHMTableViewKeyboardVisibilityHandler: SHMScrollingDelegate
{ 
    var tableView: UITableView
    
   public init(tableView: UITableView)
   {
        
        self.tableView = tableView
    }
    
   public func start()
   {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillShow), 
                                               name: NSNotification.Name.UIKeyboardWillShow,
                                               object: nil
            )
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(self.handleKeyboardDisappear),
                                                   name: NSNotification.Name.UIKeyboardWillHide, 
                                                   object: nil
        )
    }
    
   public func stop()
   {
        NotificationCenter.default.removeObserver(self)
    }
    
    public func setActive(indexPath: IndexPath){
        
        self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        
        
    }
    
    @objc fileprivate func keyboardWillShow(notification: NSNotification) 
    {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue 
        {
            let keyboardHeight = keyboardSize.height
            let insets = UIEdgeInsetsMake(0.0, 0.0, keyboardHeight, 0.0)
            tableView.contentInset =  insets
            tableView.scrollIndicatorInsets = insets
        }
    }
    
    @objc fileprivate func handleKeyboardDisappear(notification: NSNotification){
        
        tableView.contentInset = .zero
        tableView.scrollIndicatorInsets = .zero
        
    }
    
    
    deinit{
        stop()
    }
}
