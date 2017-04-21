//
//  MainViewControlle+UIScrollViewDelegate.swift
//  SHMTableView
//
//  Created by Michal Fousek on 21/04/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

extension MainViewController: UIScrollViewDelegate
{
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
    {
        print("MainViewController did end dragging. Will decelerate: \(decelerate).")
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        print("MainViewController did end decelerating.")
    }
}
