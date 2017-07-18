//
//  FibonacciNumbersTableViewController.swift
//  SHMTableView
//
//  Created by Dominik Bucher on 17/07/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import SHMTableView


class FibonacciNumbersTableViewController: SHMTableViewController
{

    
    var textToPass: String?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setupForceTouches()
        addTableViewSectionWithCell()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() 
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func addTableViewSectionWithCell()
    {
        
        
        let section = SHMTableSection()
        
        let cellZero = SHMTableRow<FibonacciTableViewCell>(
            model: FibonacciCellModel(labelTitle: "0")
        )
        section += cellZero
        
        
        let cellOne = SHMTableRow<FibonacciTableViewCell>(
            model: FibonacciCellModel(labelTitle: "1")
        )
        
        section += cellOne
                
        var a = 0
        var final = 1
        
        for _ in 0 ..< 20 {
    
            let b = a + final
            a = final
            final = b
            
            let cell = SHMTableRow<FibonacciTableViewCell>(
                model: FibonacciCellModel(labelTitle: "\(final)")
            )
            section += cell
        }
        
        shmTable += section
    }
    
    
    /// Sets up action for 
    private func setupForceTouches()
    {
    
        forceTouchHandle?.didPeek = { (indexPath, model) in
            
            guard  let cell = self.tableView.cellForRow(at: indexPath) as? FibonacciTableViewCell,
                   let previewVC = self.storyboard?.instantiateViewController(withIdentifier: "NumberController") as? NumberDetailViewController
                else { return nil }
            
            self.textToPass = cell.label.text
            previewVC.textToShow = self.textToPass
            
            return previewVC
        }
        
        forceTouchHandle?.didPop = { viewController in 
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    
    }
    
}
