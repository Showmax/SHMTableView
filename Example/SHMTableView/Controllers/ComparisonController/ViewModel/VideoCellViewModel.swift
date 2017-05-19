//
//  VideoTableViewCell.swift
//  SHMTableView
//
//  Created by Ondrej Macoszek on 11/04/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation

struct VideoCellViewModel
{
    let title: String
    
    func play()
    {
        print("play video \(title)")
    }
}
