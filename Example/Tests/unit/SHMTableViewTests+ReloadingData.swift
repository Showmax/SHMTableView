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

import XCTest
import SHMTableView
import Nimble

// MARK: - Reloading data

extension SHMTableViewTests {
    func test__reloadData__isCalledWhenForcedReload() {
        let sections = [
            SHMTableSection(rows: [
                SHMTableRow<LoggingTableViewCell>(model: "A", reusableIdentifier: LoggingTableViewCell.reusableIdentifier),
                SHMTableRow<LoggingTableViewCell>(model: "B", reusableIdentifier: LoggingTableViewCell.reusableIdentifier),
                SHMTableRow<LoggingTableViewCell>(model: "C", reusableIdentifier: LoggingTableViewCell.reusableIdentifier),
                SHMTableRow<LoggingTableViewCell>(model: "D", reusableIdentifier: LoggingTableViewCell.reusableIdentifier),
                SHMTableRow<LoggingTableViewCell>(model: "E", reusableIdentifier: LoggingTableViewCell.reusableIdentifier)
            ])
        ]
        
        self.viewController?.shmTable.reloadDataAllWasCalled = false
        
        self.viewController?.shmTable.update(withNewSections: sections, forceReloadData: true)
        
        expect(self.viewController?.shmTable.reloadDataAllWasCalled).to(beTrue())
    }
    
    func test__reloadData__isCalledWhenRemovingAllVisibleSections() {
        ensureTableWillDisplay([
            createSection(name: "A", rowCount: 100),
            createSection(name: "B", rowCount: 100),
            createSection(name: "C", rowCount: 100)
        ])
        
        self.viewController?.shmTable.reloadDataAllWasCalled = false
        self.viewController?.shmTable.reloadDataJustChangesWasCalled = false

        ensureTableWillDisplay([
            createSection(name: "B", rowCount: 110),
            createSection(name: "C", rowCount: 100),
            createSection(name: "D", rowCount: 100)
        ])
        
        expect(self.viewController?.shmTable.reloadDataJustChangesWasCalled).to(beFalse())
        expect(self.viewController?.shmTable.reloadDataAllWasCalled).to(beTrue())
    }
    
    func test__reloadDataDifferences__isCalledWhenAtLeastOneVisibleSectionIsUnchanged() {
        ensureTableWillDisplay([
            createSection(name: "A", rowCount: 5), // five rows cannot fill whole screen, thus part of B section will be visible too
            createSection(name: "B", rowCount: 100),
            createSection(name: "C", rowCount: 100)
        ])
        
        self.viewController?.shmTable.reloadDataAllWasCalled = false
        self.viewController?.shmTable.reloadDataJustChangesWasCalled = false
        
        ensureTableWillDisplay([
            createSection(name: "B", rowCount: 100),
            createSection(name: "C", rowCount: 110),
            createSection(name: "D", rowCount: 100)
        ])
        
        expect(self.viewController?.shmTable.reloadDataJustChangesWasCalled).to(beTrue())
        expect(self.viewController?.shmTable.reloadDataAllWasCalled).to(beFalse())
    }
    
    func test__update__willInitiateDataReload() {
        guard let shmTable = self.viewController?.shmTable else {
            fail("Table must exist")
            return
        }
        
        ensureTableWillDisplay([
            createSection(name: "A", rows: [
                "A row #1",
                "A row #2",
                "A row #3",
                "A row #4",
                "A row #5"
            ]),
            createSection(name: "B", rowCount: 100),
            createSection(name: "C", rowCount: 0)
        ])
        
        shmTable.reloadDataAllWasCalled = false
        shmTable.reloadDataJustChangesWasCalled = false
        
        ensureTableWillDisplay([
            createSection(name: "A", rows: [
                "A row #1",
                "A row #3",
                "A row after #3",
                "A row #4",
                "A row #5"
            ]),
            createSection(name: "B", rowCount: 100),
            createSection(name: "C", rowCount: 0),
            createSection(name: "D", rowCount: 100)
        ])
        
        expect(shmTable.reloadDataAllWasCalled || shmTable.reloadDataJustChangesWasCalled).to(beTrue())
    }
}
