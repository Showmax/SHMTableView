//
//  NumberDetailViewController.swift
//  SHMTableView
//
//  Created by Dominik Bucher on 17/07/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit

class NumberDetailViewController: UIViewController 
{
    
    let previewAction = UIPreviewAction(title: "Search me on google",
                                        style: UIPreviewActionStyle.default,
                                        handler: { _, _ in 
                                            UIApplication.shared.openURL(URL(string: "http://www.google.com/search?q=number+55")!)
    })
    
    ///Override this var to show action items in 3DTouch action
    override var previewActionItems: [UIPreviewActionItem] 
    {
        return [previewAction]
        
    }
    
    var textToShow: String?
    
    @IBOutlet var label: UILabel!

    override func viewDidLoad() 
    {
        super.viewDidLoad()
        self.label.text = textToShow
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
