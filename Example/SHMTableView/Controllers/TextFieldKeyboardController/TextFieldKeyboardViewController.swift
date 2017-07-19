//
//  TextFieldKeyboardViewController.swift
//  SHMTableView
//
//  Created by Dominik Bucher on 14/07/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import SHMTableView

class TextFieldKeyboardViewController: SHMTableViewController
{
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() 
    {
        super.viewDidLoad()
        
        fillModelIntoTable()
    }

    // MARK: - IB Outlets
    
    @IBAction func donePressed(_ sender: Any)
    {
        view.endEditing(true)
    }
    
    // MARK: - Helpers
    
    private func fillModelIntoTable()
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
