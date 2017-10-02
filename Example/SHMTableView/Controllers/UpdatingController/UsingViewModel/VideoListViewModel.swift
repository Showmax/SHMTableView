// Copyright since 2015 Showmax s.r.o.
// 
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// 
//     http://www.apache.org/licenses/LICENSE-2.0
// 
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import Foundation
import SHMTableView

/**
 
 This class manages two lists (all and kids) with content prepared to be displayed in the view.
 Content is created by transforming VideoListModel categories to sections and videos to rows.
 
 Is able to remember currently selected list and return sections for selected list.
 
 Offers shuffle method which recreates content by tranforming shuffled videos from SHMTableView.
 
 */
class VideoListViewModel {
    /// Types of managed lists
    enum List: String {
        case all = "All"
        case kids = "Kids"
    }
    
    /// Currently selected list type
    var selectedList: List = .all
    
    /// Holds prepared content with all movies to be displayed
    private var all: [SHMTableSection] = []
    
    /// Holds prepared content with just kids movies to be displayed
    private var kids: [SHMTableSection] = []
    
    /// Source of categories with both shuffled and notshuffled videos
    private let model: VideoListModel
    
    /// Creates lists content from given model
    init(model: VideoListModel) {
        self.model = model
        
        createLists(from: model.categories)
    }
    
    // MARK: - Actions
    
    /// Returns either all or kids list depending on what list is currently selected
    func sectionsForSelectedList() -> [SHMTableSection] {
        switch selectedList {
            
        case .all:
            return all
            
        case .kids:
            return kids
            
        }
    }
    
    /// Ask model for categories with shuffled videos and transform them into sections and rows
    func shuffle() {
        createLists(from: model.categoriesWithShuffledVideos)
    }

    // MARK: - Helpers

    /// Prepare list content to be displayed by transforming categories and videos to sections and rows
    private func createLists(from categories: [VideoListModel.Category]) {
        all = []
        kids = []
        for category in categories {
            let sectionForAll = SHMTableSection()
            sectionForAll.headerTitle = category.title
            
            let sectionForKids = SHMTableSection()
            sectionForKids.headerTitle = category.title
            
            for video in category.videos {
                let row = SHMTableRow<SimpleXibTableViewCell>(model: video.title)
                
                if video.isForKids {
                    sectionForKids.append(row: row)
                }
                
                sectionForAll.append(row: row)
            }
            
            all.append(sectionForAll)
            kids.append(sectionForKids)
        }
    }
}
