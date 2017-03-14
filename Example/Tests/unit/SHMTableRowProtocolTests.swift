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
import XCTest
import SHMTableView
import Nimble

class SHMTableRowProtocolTests: LoggingTableTestCase
{
    func test__configureMethods__areCalledDuringTableLoading()
    {
        ensureTableWillDisplay([
            SHMTableSection(rows: [
                SHMTableRow<LoggingTableViewCell>(model: "A", reusableIdentifier: LoggingTableViewCell.reusableIdentifier),
                SHMTableRow<LoggingTableViewCell>(model: "B", reusableIdentifier: LoggingTableViewCell.reusableIdentifier),
                SHMTableRow<LoggingTableViewCell>(model: "C", reusableIdentifier: LoggingTableViewCell.reusableIdentifier),
                SHMTableRow<LoggingTableViewCell>(model: "D", reusableIdentifier: LoggingTableViewCell.reusableIdentifier),
                SHMTableRow<LoggingTableViewCell>(model: "E", reusableIdentifier: LoggingTableViewCell.reusableIdentifier),
            ])
        ])
        
        guard let visibleCells = self.viewController?.shmTable.tableView?.visibleCells as? [LoggingTableViewCell] else
        {
            fail("Previously defined cells should be visible now")
            return
        }
        
        expect(visibleCells).toNot(beEmpty())
        
        for cell in visibleCells
        {
            expect(cell.configureMethodWasCalled).to(beTrue())
            expect(cell.configureAtWillDisplayMethodWasCalled).to(beTrue())
        }
    }
    
    func test__action__isCalledOnRowSelection()
    {
        var actionWasCalled: Bool = false
        
        let rowB = SHMTableRow<LoggingTableViewCell>(model: "B", reusableIdentifier: LoggingTableViewCell.reusableIdentifier)
        rowB.action = { indexPath in actionWasCalled = true }
        
        ensureTableWillDisplay([
            SHMTableSection(rows: [
                SHMTableRow<LoggingTableViewCell>(model: "A", reusableIdentifier: LoggingTableViewCell.reusableIdentifier),
                rowB,
                SHMTableRow<LoggingTableViewCell>(model: "C", reusableIdentifier: LoggingTableViewCell.reusableIdentifier),
                SHMTableRow<LoggingTableViewCell>(model: "D", reusableIdentifier: LoggingTableViewCell.reusableIdentifier),
                SHMTableRow<LoggingTableViewCell>(model: "E", reusableIdentifier: LoggingTableViewCell.reusableIdentifier)
            ])
        ])
        
        guard   let shmTable = self.viewController?.shmTable,
                let tableView = self.viewController?.shmTable.tableView else
        {
            fail("Table must exist")
            return
        }
        
        let selectedIndexPath = IndexPath(row: 1, section: 0)
        tableView.selectRow(at: selectedIndexPath, animated: false, scrollPosition: .none)
        shmTable.tableView(tableView, didSelectRowAt: selectedIndexPath)
        
        expect(actionWasCalled).to(beTrue())
    }
}
