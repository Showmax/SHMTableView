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
 
 This controller demonstrates how to update table when sections and rows are defined/composed using separate viewmodel.
 
 We show list of movies divided into three sections by categories ("Adventure", "Comedy" or "Documentary"). Some of movies are suitable
 primarily for kids. Using segmented control in navigationbar user can switch between showing all movies and just movies for kids.
 Right button in navigationbar shuffles all defined rows.
 
 */
class UpdatingViewModelController: SHMTableViewController {
    /// Setting up view model that handle user actions and offer data to display.
    /// Remembers which list is currently selected.
    var viewModel: VideoListViewModel = VideoListViewModel(model: VideoListModel())
    
    /// Table is initially filled with movies in currently selected list.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shmTable.update(withNewSections: viewModel.sectionsForSelectedList())
    }
    
    /// Called when user selects certain item on the segmented control in a navigation bar.
    /// Update table with currently selected list. List structure is defined within separate viewmodel class. 
    @IBAction func selectedListChanged(_ sender: Any) {
        guard   let segmentedControl = sender as? UISegmentedControl,
                let selectedTitle = segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex),
                let selectedList = VideoListViewModel.List(rawValue: selectedTitle)
                else { return }
        
        viewModel.selectedList = selectedList
        shmTable.update(withNewSections: viewModel.sectionsForSelectedList())
    }
    
    /// Called when user taps on right button in navigationbar.
    /// Ask view model to shuffle items. Finaly update table with new shuffled items.
    @IBAction func shuffleTapped(_ sender: Any) {
        viewModel.shuffle()
        shmTable.update(withNewSections: viewModel.sectionsForSelectedList())
    }
}
