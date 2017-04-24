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
 
 TableInTableModel is empty here but you can use it in case of some additional logic
 or for purpose of any interaction. (see InteractionViewController).
 
 TableInTableViewCell is instantiating another SHMTableView and uses configure() method
 to fill it with data.
 
 */

struct TableInTableModel
{
    
}

class TableInTableViewCell: UITableViewCell, SHMConfigurableRow
{
    typealias T = TableInTableModel
    
    var shmInTable: SHMTableView!
    
    @IBOutlet weak var tableView: UITableView!
    {
        didSet
        {
            shmInTable = SHMTableView(tableView: tableView)
        }
    }
    
    func configure(_ model: T)
    {
        // simple row
        let simpleSection = SHMTableSection()
        
        shmInTable += simpleSection
        
        simpleSection += SHMTableRow<SimpleXibTableViewCell>(model: "simple row at specific table")
        simpleSection += SHMTableRow<SimpleXibTableViewCell>(model: "simple row at specific table")
        simpleSection += SHMTableRow<SimpleXibTableViewCell>(model: "simple row at specific table")
        simpleSection += SHMTableRow<SimpleXibTableViewCell>(model: "simple row at specific table")
    }
    
    func configureAtWillDisplay(_ model: T)
    {
        
    }
    
    func configureOnHide(_ model: T)
    {
    }
}
