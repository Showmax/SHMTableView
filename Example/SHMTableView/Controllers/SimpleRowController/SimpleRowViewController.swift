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
 
 This controller is about to teach you some basic principles.
 
 1. How to create simple sections.
 2. How to fill it by simple rows.
 3. How to badge rows using operators.
 
 */

class SimpleRowViewController: SHMTableViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // instantiate a simple section for usage of xib's rows
        let xibSection = SHMTableSection()
        
        // the section is default one, so it uses just a title
        xibSection.headerTitle = "Rows loaded from xib"
        
        // using the += operator is a simple and easy way how you can add a row
        // a row is composed by instatiating it by SHMTableRow contructor
        xibSection += SHMTableRow<SimpleXibTableViewCell>(model: "1. xib row")
        xibSection += SHMTableRow<SimpleXibTableViewCell>(model: "2. xib row")
        xibSection += SHMTableRow<SimpleXibTableViewCell>(model: "3. xib row")

        // use the += operator even to add a section into a table
        shmTable += xibSection

        // the process is repeating...
        
        // storyboard section
        let storyboardSection = SHMTableSection()

        storyboardSection.headerTitle = "Rows loaded from storyboard"
        
        storyboardSection += SHMTableRow<SimpleStoryboardTableViewCell>(model: "1. storyboard row")
        storyboardSection += SHMTableRow<SimpleStoryboardTableViewCell>(model: "2. storyboard row")
        storyboardSection += SHMTableRow<SimpleStoryboardTableViewCell>(model: "3. storyboard row")

        shmTable += storyboardSection

        // setup the batch section
        let batchSection = SHMTableSection()
        
        batchSection.headerTitle = "Rows added by batch"

        var batch = [SHMTableRowProtocol]()
        
        for i in 1...5
        {
            batch.append(SHMTableRow<SimpleStoryboardTableViewCell>(model: "\(i). batch row"))
        }
        
        batchSection += batch
        
        shmTable += batchSection

        // setup section which is initlializzed by batch
        let sectionByBatch = SHMTableSection(rows: batch)
        
        sectionByBatch.headerTitle = "Section initialized by batch"
        sectionByBatch.footerTitle = "End of Section initialized by batch"
        
        shmTable += sectionByBatch

        // setup section which is initlializzed by reversed batch
        let sectionByReversedBatch = SHMTableSection(rows: batch.reversed())
        
        sectionByReversedBatch.headerTitle = "Section initialized by reversed batch"
        
        shmTable += sectionByReversedBatch
    }
}
