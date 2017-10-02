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

import UIKit
import SHMTableView

/**
 
 This controller is about to teach you how to build a connection between rows.
 
 This example is presenting 2 rows. One is a collection view with categories like cats, cities, food, etc.
 The other is a collection of pictures downloaded from the web. The first one is controling the second one.
 
 When user taps on a category it reloads pictures. The real downloading is handled by CarouselTableViewCell. 
 
 */

class CarouselViewController: SHMTableViewController {
    var viewModel = CarouselViewModel(category: .city)
    
    lazy var categoriesViewModel: CategoriesViewModel = {
        return CategoriesViewModel(
            categories: [.city, .food, .nature, .cats, .technics],
            selectedCategory: self.viewModel.category,
            categoryAction: { [weak self] category in
                
                guard let me = self else {
                    return
                }
                
                DispatchQueue.main.async {
                        me.categoriesViewModel.selectedCategory = category
                        me.viewModel.category = category
                        me.shmTable.tableView?.reloadData()
                }
            }
        )
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let carouselSection = SHMTableSection()
        
        shmTable += carouselSection
        shmTable += SHMTableRow<CategoriesTableViewCell>(model: categoriesViewModel)
        shmTable += SHMTableRow<CarouselTableViewCell>(model: viewModel)
    }
}
