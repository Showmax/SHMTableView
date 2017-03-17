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
import UIKit

/**
 
 This controller demonstrates how to update table with new sections and rows.
 
 We show list of movies divided into three sections by categories ("Adventure", "Comedy" or "Documentary"). Some of movies are suitable
 primarily for kids. Using segmented control in navigationbar user can switch between showing all movies and just movies for kids.
 
 When SHMTableView receives new sections and rows to display it will compute difference to currently displayed sections and rows. 
 According to found differences will perform deletion or insertion animations.
 
 Here you can see how to define sections and rows for simple cases.
 For more complex cases we suggest to move out logic into separate class like viewmodel.
 
 */

#if os(tvOS)
let simpleCellIdentifier = "SimpleXibTableViewCell+tvOS"
#else
let simpleCellIdentifier = "SimpleXibTableViewCell"
#endif

class UpdatingSimpleController: SHMTableViewController
{
    /// All movies divided into sections by category. Each section has category name as header title.
    /// Rows are created by mapping model (String with movie name) to the view type (SimpleXibTableViewCell) in which we want to show passed model.
    lazy var sectionsForAll: [SHMTableSection] =
    {
        let adventures = SHMTableSection()
        adventures.headerTitle = "Adventures"
        adventures.rows = [
            SHMTableRow<SimpleXibTableViewCell>(model:"Atlantis", reusableIdentifier: simpleCellIdentifier),
            SHMTableRow<SimpleXibTableViewCell>(model:"Bedtime Stories", reusableIdentifier: simpleCellIdentifier),
            SHMTableRow<SimpleXibTableViewCell>(model:"Disney Favourites", reusableIdentifier: simpleCellIdentifier),
            SHMTableRow<SimpleXibTableViewCell>(model:"Game Of Thrones", reusableIdentifier: simpleCellIdentifier),
            SHMTableRow<SimpleXibTableViewCell>(model:"Mission: Impossible", reusableIdentifier: simpleCellIdentifier),
            SHMTableRow<SimpleXibTableViewCell>(model:"Piggy Tales", reusableIdentifier: simpleCellIdentifier),
            SHMTableRow<SimpleXibTableViewCell>(model:"Stargate", reusableIdentifier: simpleCellIdentifier),
            SHMTableRow<SimpleXibTableViewCell>(model:"Transformers", reusableIdentifier: simpleCellIdentifier)
        ]
        
        let comedy = SHMTableSection()
        comedy.headerTitle = "Comedy"
        comedy.rows = [
            SHMTableRow<SimpleXibTableViewCell>(model:"101 Dalmations", reusableIdentifier: simpleCellIdentifier),
            SHMTableRow<SimpleXibTableViewCell>(model:"Alladin", reusableIdentifier: simpleCellIdentifier),
            SHMTableRow<SimpleXibTableViewCell>(model:"Big Bang Theory", reusableIdentifier: simpleCellIdentifier),
            SHMTableRow<SimpleXibTableViewCell>(model:"Friends", reusableIdentifier: simpleCellIdentifier),
            SHMTableRow<SimpleXibTableViewCell>(model:"Little Fockers", reusableIdentifier: simpleCellIdentifier),
            SHMTableRow<SimpleXibTableViewCell>(model:"Shaun The Sheep", reusableIdentifier: simpleCellIdentifier),
            SHMTableRow<SimpleXibTableViewCell>(model:"Smurfs", reusableIdentifier: simpleCellIdentifier),
            SHMTableRow<SimpleXibTableViewCell>(model:"Sex And The City", reusableIdentifier: simpleCellIdentifier),
            SHMTableRow<SimpleXibTableViewCell>(model:"Silicon Valley", reusableIdentifier: simpleCellIdentifier)
        ]
        
        let documentary = SHMTableSection()
        documentary.headerTitle = "Documentary"
        documentary.rows = [
            SHMTableRow<SimpleXibTableViewCell>(model:"Blue Planet", reusableIdentifier: simpleCellIdentifier),
            SHMTableRow<SimpleXibTableViewCell>(model:"David Attenborough's Natural Curiosities", reusableIdentifier: simpleCellIdentifier),
            SHMTableRow<SimpleXibTableViewCell>(model:"Lions On The Move", reusableIdentifier: simpleCellIdentifier),
            SHMTableRow<SimpleXibTableViewCell>(model:"Mandela", reusableIdentifier: simpleCellIdentifier),
            SHMTableRow<SimpleXibTableViewCell>(model:"One Life", reusableIdentifier: simpleCellIdentifier),
            SHMTableRow<SimpleXibTableViewCell>(model:"Shoreline", reusableIdentifier: simpleCellIdentifier)
        ]
        
        return [
            adventures,
            comedy,
            documentary
        ]
    }()
    
    /// Movies suitable mainly for kids are divided into sections by category. Each section has category name as header title.
    /// Rows are created by mapping model (String with movie name) to the view type (SimpleXibTableViewCell) in which we want to show passed model.
    lazy var sectionsForKids: [SHMTableSection] =
    {
        let adventures = SHMTableSection()
        adventures.headerTitle = "Adventures"
        adventures.rows = [
            SHMTableRow<SimpleXibTableViewCell>(model:"Bedtime Stories", reusableIdentifier: simpleCellIdentifier),
            SHMTableRow<SimpleXibTableViewCell>(model:"Disney Favourites", reusableIdentifier: simpleCellIdentifier),
            SHMTableRow<SimpleXibTableViewCell>(model:"Piggy Tales", reusableIdentifier: simpleCellIdentifier)
        ]
        
        let comedy = SHMTableSection()
        comedy.headerTitle = "Comedy"
        comedy.rows = [
            SHMTableRow<SimpleXibTableViewCell>(model:"101 Dalmations", reusableIdentifier: simpleCellIdentifier),
            SHMTableRow<SimpleXibTableViewCell>(model:"Alladin", reusableIdentifier: simpleCellIdentifier),
            SHMTableRow<SimpleXibTableViewCell>(model:"Shaun The Sheep", reusableIdentifier: simpleCellIdentifier),
            SHMTableRow<SimpleXibTableViewCell>(model:"Smurfs", reusableIdentifier: simpleCellIdentifier)
        ]
        
        let documentary = SHMTableSection()
        documentary.headerTitle = "Documentary"
        documentary.rows = [
            SHMTableRow<SimpleXibTableViewCell>(model:"Blue Planet", reusableIdentifier: simpleCellIdentifier)
        ]
        
        return [
            adventures,
            comedy,
            documentary
        ]
    }()
    
    @IBOutlet weak var segmentedControl: UISegmentedControl?
    
    /// Table is initially filled with all movies when displayed for the first time.
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        title = "Updating Example"
        
        shmTable.update(withNewSections: sectionsForAll)
    }
    
    /// Called when user selects certain item on the segmented control in a navigation bar.
    /// Update table with all movies if first item is selected, otherwise update with just kids movies.
    @IBAction func selectedListChanged(_ sender: Any)
    {
        guard let segmentedControl = sender as? UISegmentedControl else { return }
        
        if segmentedControl.selectedSegmentIndex == 0
        {
            shmTable.update(withNewSections: sectionsForAll)
            
        } else
        {
            shmTable.update(withNewSections: sectionsForKids)
        }
    }
}
