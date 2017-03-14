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
 
 This controller is about to teach you how to use table inside a cell.
 
 */

class TableInTableViewController: SHMTableViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // create table in table section and add a row
        let tableInTableSection = SHMTableSection()
        
        tableInTableSection.headerTitle = "Table in row BEGIN"
        tableInTableSection.footerTitle = "Table in row END"
        
        shmTable += tableInTableSection
        
        // the business logic here is hidden inside a "TableInTableViewCell" go into and look at
        tableInTableSection += SHMTableRow<TableInTableViewCell>(model: TableInTableModel())

        // simple row
        let simpleSection = SHMTableSection()
        
        simpleSection.headerTitle = "Simple section BEGIN"
        simpleSection.footerTitle = "Simple section END"
        
        shmTable += simpleSection
        
        simpleSection += SHMTableRow<SimpleXibTableViewCell>(model: "simple row")
    }
}
