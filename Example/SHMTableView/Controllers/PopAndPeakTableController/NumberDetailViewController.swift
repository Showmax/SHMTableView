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
    var textToShow: String?
 
    /// Label showing the number in the center of view
    @IBOutlet var label: UILabel!
    
    /// Override this var to show action items in 3DTouch action
    override var previewActionItems: [UIPreviewActionItem] 
    {
        return previewActions()
    }
    
    override func viewDidLoad() 
    {
        super.viewDidLoad()
        
        label.text = textToShow
    }
}

// MARK: - Adding preview actions

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
