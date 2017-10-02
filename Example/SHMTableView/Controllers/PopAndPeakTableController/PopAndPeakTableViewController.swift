//
//  PopAndPeakTableViewController.swift
//  SHMTableView
//
//  Created by Dominik Bucher on 17/07/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import SHMTableView

class PopAndPeakTableViewController: SHMTableViewController {
    var textToPass: String?
    
    var modelList: [FibonacciCellModel]?
    
    // MARK: - View controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupForceTouches()
        createModel()
        fillModelToView()
    }
        
    // MARK: - Helpers
    
    private func setupForceTouches() {
        didPeek = { [weak self] (indexPath) in
            
            guard   let model = self?.findModel(indexPath: indexPath),
                    let previewVC = self?.storyboard?.instantiateViewController(withIdentifier: "NumberController") as? NumberDetailViewController
            else { return nil }
            
            previewVC.textToShow = model.labelTitle
            
            return previewVC
        }
        
        didPop = { [weak self] viewController in
            
            self?.navigationController?.pushViewController(viewController, animated: true)
        }
    }

    private func fillModelToView() {
        guard let modelList = modelList else { return }
                
        let section = SHMTableSection()
        
        for model in modelList {
            section += SHMTableRow<FibonacciTableViewCell>(model: model)
        }
        
        shmTable += section
    }
    
    private func createModel() {
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
    
    private func findModel(indexPath: IndexPath) -> FibonacciCellModel? {
        return modelList?[safe: indexPath.row]
    }
}
