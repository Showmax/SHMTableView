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

class CarouselViewModel {
    var category: Category
    
    init(category: Category) {
        self.category = category
    }
}

class CarouselTableViewCell: UITableViewCell, SHMConfigurableRow, UICollectionViewDelegate, UICollectionViewDataSource {
    typealias T = CarouselViewModel
    
    var viewModel: CarouselViewModel? = nil
    var imgData = [Data]()
    
    @IBOutlet var colView: UICollectionView!
    
    func configure(_ viewModel: T) {
        self.viewModel = viewModel
    }
    
    func configureAtWillDisplay(_ model: T) {
        guard let category = viewModel?.category else {
            return
        }
        
        imgData.removeAll()
        
        for i in 1...10 {
            let urlPath = "http://lorempixel.com/318/318/\(category)/\(i)/"
            
            guard let endpoint = URL(string: urlPath) else {
                return
            }
            
            let request = URLRequest(url: endpoint)
            
            let task = URLSession.shared.dataTask(with: request) { [weak self] (data, _, _) in

                guard let data = data else {
                    return
                }
                
                guard let me = self else {
                    return
                }
                
                me.imgData.append(data)
                
                //
                if me.imgData.count == 10 {
                    DispatchQueue.main.async {
                        me.colView.reloadData()
                    }
                }
                
            }
                
            task.resume()
        }
    }
    
    func configureOnHide(_ model: T) {
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CarouselCollectionViewCell", for: indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if  let carouselCell = cell as? CarouselCollectionViewCell,
            indexPath.row < imgData.count {
            carouselCell.image.image = UIImage(data: imgData[indexPath.row])  
        }
    }
}
