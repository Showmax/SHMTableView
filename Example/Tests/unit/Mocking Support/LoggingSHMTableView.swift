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
@testable import SHMTableView

class LoggingSHMTableView: SHMTableView {
    var reloadDataAllWasCalled: Bool = false
    var reloadDataJustChangesWasCalled: Bool = false
    var loggedSectionHeaderTitles: [Int: String?] = [:]
    var loggedSectionFooterTitles: [Int: String?] = [:]
    var loggedSectionHeaderViews: [Int: UIView?] = [:]
    var loggedSectionFooterViews: [Int: UIView?] = [:]
    var loggedNumberOfSections: Int = 0
    var loggedSectionsAndRows: [Int: Int?] = [:]
    
    override func reloadDataAll() {
        super.reloadDataAll()
        
        reloadDataAllWasCalled = true
    }
    
    override func reloadDataJustChanges(_ changes: SHMTableChangesFinderChanges, rowAnimation: UITableViewRowAnimation) {
        super.reloadDataJustChanges(changes, rowAnimation: rowAnimation)
        
        reloadDataJustChangesWasCalled = true
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let response = super.tableView(tableView, titleForHeaderInSection: section)
        
        loggedSectionHeaderTitles[section] = response
        
        return response
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        let response = super.tableView(tableView, titleForFooterInSection: section)
        
        loggedSectionFooterTitles[section] = response
        
        return response
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let response = super.tableView(tableView, viewForHeaderInSection: section)
        
        loggedSectionHeaderViews[section] = response
        
        return response
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let response = super.tableView(tableView, viewForFooterInSection: section)
        
        loggedSectionFooterViews[section] = response
        
        return response
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        let response = super.numberOfSections(in: tableView)
        
        loggedNumberOfSections = response
        
        return response
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let response = super.tableView(tableView, numberOfRowsInSection: section)
        
        loggedSectionsAndRows[section] = response
        
        return response
    }
}
