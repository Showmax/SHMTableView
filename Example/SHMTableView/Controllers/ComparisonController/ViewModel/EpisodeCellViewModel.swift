//
//  EpisodeTableViewCell.swift
//  SHMTableView
//
//  Created by Ondrej Macoszek on 11/04/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation

struct EpisodeCellViewModel {
    let number: Int
    let title: String
    
    func openDetail() {
        print("open detail for \(title)")
    }
}
