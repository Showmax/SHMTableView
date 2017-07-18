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
    
    var modelList: [FibonacciCellModel]?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setupForceTouches()
        createModel()
        fillModelToView()
    }
        
    // MARK: - Helpers
    
    
    /// Sets up action for 
    private func setupForceTouches()
    {
        
        forceTouchHandle?.didPeek = { (indexPath) in
            
            guard  let model = self.findModel(indexPath: indexPath),
                let previewVC = self.storyboard?.instantiateViewController(withIdentifier: "NumberController") as? NumberDetailViewController
                else { return nil }
            
            previewVC.textToShow = model.labelTitle
            
            return previewVC
        }
        
        forceTouchHandle?.didPop = { viewController in 
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        
    }

    
    
    private func fillModelToView()
    {
        guard let modelList = modelList else { return }
                
        let section = SHMTableSection()
        
        for model in modelList
        {
            section += SHMTableRow<FibonacciTableViewCell>(model: model)
        }
        
        shmTable += section
    }
    
    
    private func createModel()
    {
        
        // Create model 
        
        modelList = [
            FibonacciCellModel(labelTitle: "0"),
            FibonacciCellModel(labelTitle: "1")
        ]
        
        var a = 0
        var final = 1
        
        for _ in 0 ..< 20 {
            
            let b = a + final
            a = final
            final = b
            modelList?.append(FibonacciCellModel(labelTitle: "\(final)"))
        }
        
    }
    
    private func findModel(indexPath: IndexPath) -> FibonacciCellModel?
    {
        return modelList?[indexPath.row]
    }
    
}



extension Collection where Indices.Iterator.Element == Index 
{
    
    /// Returns the element at the specified index iff it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Generator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
