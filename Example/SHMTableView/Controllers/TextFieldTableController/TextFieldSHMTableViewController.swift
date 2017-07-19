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
    var keyboardHandler: SHMTableViewKeyboardVisibilityHandler?
    
    override func viewDidLoad() 
    {
        super.viewDidLoad()
        
        keyboardHandler = SHMTableViewKeyboardVisibilityHandler(tableView: tableView)
        
        addTableViewSectionWithCell()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        keyboardHandler?.start()
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(true)
        keyboardHandler?.stop()
    }
    
    @IBAction func donePressed(_ sender: Any)
    {
        view.endEditing(true)
    }
    
    private func addTableViewSectionWithCell()
    {
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
}
