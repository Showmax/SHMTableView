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



public class SHMTableViewKeyboardVisibilityHandler
{ 
    weak var tableView: UITableView?
    
    
   public init(tableView: UITableView?)
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
    
    @objc fileprivate func keyboardWillShow(notification: NSNotification) 
    {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue 
        {
            let keyboardHeight = keyboardSize.height
            
            guard let tableView = tableView else { return }
            
            var insets = tableView.contentInset 
            insets.bottom = keyboardHeight
            tableView.contentInset =  insets
        }
    }
    
    @objc fileprivate func handleKeyboardDisappear(notification: NSNotification)
    {
        guard let tableView = tableView else { return }
        
        var insets = tableView.contentInset 
        insets.bottom = 0
        tableView.contentInset =  insets
        
    }
    
    deinit
    {
        stop()
    }
}
