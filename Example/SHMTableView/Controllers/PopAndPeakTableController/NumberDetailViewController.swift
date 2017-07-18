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
    
    
    
    ///Override this var to show action items in 3DTouch action
    override var previewActionItems: [UIPreviewActionItem] 
    {
        return previewActions()
        
    }
    
    /// Label showing the number in the center of view
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

    // MARK: Adding preview actions

extension NumberDetailViewController
{

    func previewActions() -> [UIPreviewAction]
    {
        let googleSearch = UIPreviewAction(title: "Search me with google",
                                            style: UIPreviewActionStyle.default,
                                            handler: { _, _ in 
                                                guard let number = self.textToShow,
                                                      let  url = URL(string: "http://www.google.com/search?q=number+\(number)") 
                                                      else { return }
                                                UIApplication.shared.openURL(url)
        })
        
        let goldenRatio = UIPreviewAction(title: "Google golden ratio",
                                           style: UIPreviewActionStyle.default,
                                           handler: { _, _ in 
                                            guard let  url = URL(string: "http://www.google.com/search?q=golden+ratio") 
                                                  else { return }
                                            UIApplication.shared.openURL(url)
        })
    
        return [googleSearch, goldenRatio]
    }
    




}
