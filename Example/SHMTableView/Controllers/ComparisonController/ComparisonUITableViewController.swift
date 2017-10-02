//
//  ComparisonUITableViewController.swift
//  SHMTableView
//
//  Created by Ondrej Macoszek on 11/04/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

class ComparisonUITableViewController: UIViewController {
    @IBOutlet open weak var tableView: UITableView!
    
    var items: [Any] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        items = [
            EpisodeCellViewModel(number: 7, title: "The One With The Race Car Bed"),
            EpisodeCellViewModel(number: 8, title: "The One With The Giant Poking Device"),
            EpisodeCellViewModel(number: 9, title: "The One With The Footbal"),
            VideoCellViewModel(title: "Video preview for 'The One With The Footbal'"),
            EpisodeCellViewModel(number: 10, title: "The One Where Rachel Quits"),
            EpisodeCellViewModel(number: 11, title: "The One Where Chandler Can't Remember Which Sister")
        ]
    
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 44
        
        tableView?.register(UINib(nibName: "EpisodeTableViewCell", bundle: nil), forCellReuseIdentifier: "EpisodeTableViewCell")
        tableView?.register(UINib(nibName: "VideoTableViewCell", bundle: nil), forCellReuseIdentifier: "VideoTableViewCell")
    }
}

extension ComparisonUITableViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.row < items.count else {
            fatalError("Requesting cell on indexPath \(indexPath) out of bounds.")
        }
    
        let item = items[indexPath.row]
        
        if  let episode = item as? EpisodeCellViewModel,
            let cell = tableView.dequeueReusableCell(withIdentifier: "EpisodeTableViewCell", for: indexPath) as? EpisodeTableViewCell {
            cell.configure(episode)
            return cell
            
        } else if   let video = item as? VideoCellViewModel,
                    let cell = tableView.dequeueReusableCell(withIdentifier: "VideoTableViewCell", for: indexPath) as? VideoTableViewCell {
            cell.configure(video)
            return cell
        }
        
        fatalError("Cannot create cell for requested indexPath \(indexPath).")
    }
}

extension ComparisonUITableViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard indexPath.row < items.count else {
            return
        }
        
        let item = items[indexPath.row]
        
        if  let episode = item as? EpisodeCellViewModel,
            let cell = tableView.dequeueReusableCell(withIdentifier: "EpisodeTableViewCell", for: indexPath) as? EpisodeTableViewCell {
            cell.configureAtWillDisplay(episode)
            
        } else if   let video = item as? VideoCellViewModel,
                    let cell = tableView.dequeueReusableCell(withIdentifier: "VideoTableViewCell", for: indexPath) as? VideoTableViewCell {
            cell.configureAtWillDisplay(video)
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < items.count else {
            return
        }
        
        let item = items[indexPath.row]
        
        if let episode = item as? EpisodeCellViewModel {
            episode.openDetail()
            
        } else if let video = item as? VideoCellViewModel {
            video.play()
        }
    }
}
