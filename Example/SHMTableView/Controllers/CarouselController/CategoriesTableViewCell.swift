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

enum Category: String
{
    case city
    case sports
    case food
    case nature
    case cats
    case people
    case technics
}

class CategoriesViewModel
{
    let categories: [Category]
    let categoryAction: (Category) -> Void
    var selectedCategory: Category
    
    init(categories: [Category], selectedCategory: Category, categoryAction: @escaping (Category) -> Void)
    {
        self.categories = categories
        self.selectedCategory = selectedCategory
        self.categoryAction = categoryAction
    }
}

class CategoriesTableViewCell: UITableViewCell, SHMConfigurableRow, UICollectionViewDelegate, UICollectionViewDataSource
{
    typealias T = CategoriesViewModel
    
    var categoriesModel: CategoriesViewModel? = nil
    
    @IBOutlet var colView: UICollectionView!
    
    func configure(_ categoriesModel: T)
    {
        self.categoriesModel = categoriesModel
        
        colView.reloadData()
    }
    
    func configureAtWillDisplay(_ model: T)
    {
    }
    
    func configureOnHide(_ model: T)
    {
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if let categories = categoriesModel?.categories
        {
            return categories.count
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath)

        if let carouselCell = cell as? CategoryCollectionViewCell, let categories = categoriesModel?.categories
        {
            if categories[indexPath.row] == categoriesModel?.selectedCategory
            {
                carouselCell.label.textColor = UIColor.red
                
            } else
            {
                carouselCell.label.textColor = UIColor.black
            }
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
    {
        if let carouselCell = cell as? CategoryCollectionViewCell, let categories = categoriesModel?.categories
        {
            carouselCell.label.text = categories[indexPath.row].rawValue
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if let categories = categoriesModel?.categories
        {
            categoriesModel?.categoryAction(categories[indexPath.row])
        }
    }
}
