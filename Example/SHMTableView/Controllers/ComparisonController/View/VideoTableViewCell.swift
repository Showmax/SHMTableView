//
//  VideoTableViewCell.swift
//  SHMTableView
//
//  Created by Ondrej Macoszek on 11/04/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import SHMTableView

class VideoTableViewCell: UITableViewCell, SHMConfigurableRow {
    typealias T = VideoCellViewModel
    
    @IBOutlet var label: UILabel!
    
    func configure(_ model: T) {
        label.text = model.title
    }
    
    func configureAtWillDisplay(_ model: T) {
        print("Will display Video Cell with title \(model.title)")
    }
    
    func configureOnHide(_: T) {
        
    }
}
