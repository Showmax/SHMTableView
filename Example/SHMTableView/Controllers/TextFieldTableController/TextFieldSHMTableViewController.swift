//
//  TextFieldSHMTableViewController.swift
//  SHMTableView
//
//  Created by Dominik Bucher on 14/07/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import SHMTableView


class TextFieldSHMTableViewController: SHMTableViewController
{
    
    var keyboardHandler: SHMTableViewKeyboardVisibilityHandler!
    
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        self.edgesForExtendedLayout = []
        
        if keyboardHandler == nil
        {
        self.keyboardHandler = SHMTableViewKeyboardVisibilityHandler(tableView: tableView)
        }
    }
    
    
    
    @IBAction func donePressed(_ sender: Any)
    {
        self.view.endEditing(true)
    }
    
    
    override func viewDidLoad() 
    {
     super.viewDidLoad()
        
        keyboardHandler = SHMTableViewKeyboardVisibilityHandler(tableView: tableView)
        keyboardHandler.start()
        let section = SHMTableSection()
        
    
        for i in 0...20
        {
            let cell = SHMTableRow<TextFieldTableViewCell>(
                model: TextViewCellModel(placeholder: "\(i)")
            )

            section += cell
        }
        


        shmTable += section
    }
    
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(true)
        keyboardHandler.stop()
    }
   
}
