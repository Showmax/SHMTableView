//
//  SHMTableViewKeyboardVisibilityHandler.swift
//  Pods
//
//  Created by Dominik Bucher on 14/07/2017.
//

import Foundation
import UIKit

///
/// This class basically handles keyboard appearance in ViewController with UITableView.
/// You should initialize this class in viewDidLoad and call the main method start() on viewWillAppear(_:) and stop() on viewWillDisappear(_:)
/// This ensures that the keyboard notifications observing will occur only once and not multiple times.
/// 
public class SHMTableViewKeyboardVisibilityHandler
{ 
    weak var tableView: UITableView?
    
    public init(tableView: UITableView?)
    {
        self.tableView = tableView        
    }
    
    deinit
    {
        stop()
    }
    
    /// Should be called in viewDidAppear(_ animated: Bool). 
    /// Handles registering notifications for showing and hiding keyboard,
    /// specifically NSNotification.Name.UIKeyboardWillShow and NSNotification.Name.UIKeyboardWillHide
    public func start()
    {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillShow), 
            name: NSNotification.Name.UIKeyboardWillShow,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.handleKeyboardDisappear),
            name: NSNotification.Name.UIKeyboardWillHide, 
            object: nil
        )
    }
    
    /// Should be called on deinit and viewWillDisappear(_ animated: Bool)
    /// This method removes previously subscribed observer for keyboard notifications.
    public func stop()
    {
        NotificationCenter.default.removeObserver(self)
    }
    
    /// Sets the bottom property of contentInset in the tableView to keyboard height value on
    /// notification of showing  keyboard
    ///
    /// - Parameter notification: NSNofification.Name.UIKeyboardWillShow
    @objc
    private func keyboardWillShow(notification: NSNotification)
    {
        guard   let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue,
                let tableView = tableView
        else { return }
        
        let keyboardHeight = keyboardSize.height
        
        var insets = tableView.contentInset 
        insets.bottom = keyboardHeight
        tableView.contentInset = insets
    }
    
    /// Sets the bottom property of contentInset in the tableView to zero on
    /// notification of hiding keyboard
    ///
    /// - Parameter notification: NSNofification.Name.UIKeyboardWillHide
    @objc
    private func handleKeyboardDisappear(notification: NSNotification)
    {
        guard let tableView = tableView else { return }
        
        var insets = tableView.contentInset 
        insets.bottom = 0
        tableView.contentInset = insets
    }
}
