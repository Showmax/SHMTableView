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
        self.registerForPreviewing(with: self, sourceView: self.view)
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) 
     {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension FibonacciNumbersTableViewController: UIViewControllerPreviewingDelegate
{
    
    
    @available(iOS 9.0, *)
    public func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController?
    {
        let cellPostion = tableView.convert(location, from: view)
        guard let  indexPath = tableView.indexPathForRow(at: cellPostion) else { return nil }
        
        guard  let cell = tableView.cellForRow(at: indexPath) as? FibonacciTableViewCell,
            let previewVC = storyboard?.instantiateViewController(withIdentifier: "NumberController") as? NumberDetailViewController
            else { return nil }
        
        textToPass = cell.label.text
        previewVC.textToShow = textToPass
        
        return previewVC
    }
    
    @available(iOS 9.0, *)
    public func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController)
    {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "NumberController") as? NumberDetailViewController else 
        { return }
        
        vc.textToShow = textToPass
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    /*
     Note: This is only for case that user exited application, disabled 3DTouch capability 
     and then came back into the app. 
     
     
     override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?)
     {
     super.traitCollectionDidChange(previousTraitCollection)
     if isForceTouchAvailable
     {
     guard let previewingContext = previewingContext
     else 
     {
     self.previewingContext = registerForPreviewing(with: self, sourceView: view)
     return
     }
     unregisterForPreviewing(withContext: previewingContext)
     }
     }
     */
}
