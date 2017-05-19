//
//  ComparisonSHMTableViewController.swift
//  SHMTableView
//
//  Created by Ondrej Macoszek on 11/04/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import SHMTableView

class ComparisonSHMTableViewController: UIViewController
{
    public var shmTable: SHMTableView!
    @IBOutlet open weak var tableView: UITableView!
    
    var items: [Any] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        items = [
            EpisodeCellViewModel(number: 7, title: "The One With The Race Car Bed"),
            EpisodeCellViewModel(number: 8, title: "The One With The Giant Poking Device"),
            EpisodeCellViewModel(number: 9, title: "The One With The Footbal"),
            VideoCellViewModel(title: "Video preview for 'The One With The Footbal'"),
            EpisodeCellViewModel(number: 10, title: "The One Where Rachel Quits"),
            EpisodeCellViewModel(number: 11, title: "The One Where Chandler Can't Remember Which Sister")
        ]
        
        let rows = items.flatMap({ item -> SHMTableRowProtocol? in
            
            if let episode = item as? EpisodeCellViewModel
            {
                return SHMTableRow<EpisodeTableViewCell>(model: episode, action: { _ in episode.openDetail() })
                
            } else if let video = item as? VideoCellViewModel
            {
                return SHMTableRow<VideoTableViewCell>(model: video, action: { _ in video.play() })
                
            } else
            {
                return nil
            }
        })
        
        shmTable = SHMTableView(tableView: tableView)
        shmTable += SHMTableSection(rows: rows)   
    }
}
