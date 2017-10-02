//
//  SHMTableViewKeyboardVisibilityHandler.swift
//  Pods
//
//  Created by Dominik Bucher on 14/07/2017.
//

import Foundation
import UIKit

/// Class is responsible for resizing bottom contentInset of given UITableView when keyboard appears.
///
/// Usually this class is created in UIViewController where we assign to it certain UITableView.
/// To start receiving keyboard notifications call method start() - usually inside viewDidAppear(_:)
/// To stop receiving keyboard notification scall method stop() - usually inside viewDidDisappear(_:)
/// 
public class SHMTableViewKeyboardVisibilityHandler { 
    /// Table view which bottom contentInset we will update in case keyboard is shown/hidden
    weak var tableView: UITableView?
    
    /// Flag guarding that we won't subscribe multiple times to receiving keyboard notifications
    private var isSubscribed: Bool
    
    public init(tableView: UITableView?) {
        self.tableView = tableView
        self.isSubscribed = false
    }
    
    deinit {
        stop()
    }
    
    /// Register for receiving notificions related to showing and hiding keyboard,
    /// specifically NSNotification.Name.UIKeyboardWillShow and NSNotification.Name.UIKeyboardWillHide
    /// 
    /// Should be called in viewDidAppear(_ animated: Bool).
    ///
    /// If method is called multiple times, we won't subscribe to notifications again when we are already subscribed.
    public func start() {
        guard !isSubscribed else { return }
        
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
        
        isSubscribed = true
    }
    
    /// Remove previously subscribed observer for keyboard notifications.
    ///
    /// Should be called on deinit and viewWillDisappear(_ animated: Bool)
    public func stop() {
        NotificationCenter.default.removeObserver(self)
        
        isSubscribed = false
    }
    
    /// Sets the bottom property of contentInset in the tableView to keyboard height value on
    /// notification of showing  keyboard
    ///
    /// - Parameter notification: NSNofification.Name.UIKeyboardWillShow
    @objc
    private func keyboardWillShow(notification: NSNotification) {
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
    private func handleKeyboardDisappear(notification: NSNotification) {
        guard let tableView = tableView else { return }
        
        var insets = tableView.contentInset 
        insets.bottom = 0
        tableView.contentInset = insets
    }
}
