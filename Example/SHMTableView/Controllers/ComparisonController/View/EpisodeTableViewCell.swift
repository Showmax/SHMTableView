//
//  EpisodeTableViewCell.swift
//  SHMTableView
//
//  Created by Ondrej Macoszek on 11/04/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import SHMTableView

class EpisodeTableViewCell: UITableViewCell, SHMConfigurableRow {
    typealias T = EpisodeCellViewModel
    
    @IBOutlet var label: UILabel!
    
    func configure(_ model: T) {
        label.text = "Episode No. \(model.number): \(model.title)"
    }
    
    func configureAtWillDisplay(_ model: T) {
        print("Will display Episode Cell with title \(model.title)")
    }
    
    func configureOnHide(_: T) {
        
    }
}
