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

class SHMTableViewTests: LoggingTableTestCase
{
    // MARK: - Basics
    
    func test__append__willAddSectionAfterExistingTableSections()
    {
        let section = SHMTableSection()
        self.viewController?.shmTable.append(section: section)
        
        expect(self.viewController?.shmTable.sections.last).to(beIdenticalTo(section))
    }
    
    func test__append__willNotTriggerDataReloading()
    {
        guard let shmTable = self.viewController?.shmTable else
        {
            fail("Table must exist")
            return
        }
        
        let section = SHMTableSection()
        self.viewController?.shmTable.append(section: section)
        
        expect(shmTable.reloadDataAllWasCalled && shmTable.reloadDataJustChangesWasCalled).to(beFalse())
    }

    
    // MARK: - Registering NIBs
    
    func test__tableFilledWithRows__hasAllRequiredNibsRegistered()
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
        
        expect(self.viewController?.shmTable.registeredNibs).to(contain(LoggingTableViewCell.reusableIdentifier))
    }
    
    func test__registeringUnknownNib__willThrowError()
    {
        let sections = [
            SHMTableSection(rows: [
                SHMTableRow<LoggingTableViewCell>(model: "A", reusableIdentifier: LoggingTableViewCell.reusableIdentifier),
                SHMTableRow<LoggingTableViewCell>(model: "B", reusableIdentifier: LoggingTableViewCell.reusableIdentifier),
                SHMTableRow<LoggingTableViewCell>(model: "C", reusableIdentifier: LoggingTableViewCell.reusableIdentifier),
                SHMTableRow<LoggingTableViewCell>(model: "D", reusableIdentifier: LoggingTableViewCell.reusableIdentifier),
                SHMTableRow<MissingNIBTableViewCell>(model: "E")
            ])
        ]
        
        expect {
            
            self.ensureTableWillDisplay(sections)
            
        }.to(raiseException { (exception: NSException) in
            
            expect(exception.name.rawValue).to(equal("NSInternalInconsistencyException"))
            expect(exception.reason).to(contain("Could not load NIB in bundle"))
            
        })
    }
    
    
    // MARK: - Data Source Edge Cases
    
    func test__emptyDataSource__shouldDisplayEmptyTableView()
    {
        guard let loggedNumberOfSections = self.viewController?.shmTable.loggedNumberOfSections else
        {
            fail("Should be able to receive logged number of sections")
            return
        }
        
        expect(loggedNumberOfSections).to(equal(0))
    }
    
    func test__sectionWithNoRows__shouldBeDisplayedInTableView()
    {
        ensureTableWillDisplay([
            createSection(name: "A", rowCount: 100),
            createSection(name: "B", rowCount: 0),
            createSection(name: "C", rowCount: 100),
        ])
        
        guard let loggedNumberOfSections = self.viewController?.shmTable.loggedSectionsAndRows else
        {
            fail("Should be able to receive logged number of sections and rows")
            return
        }
        
        guard let loggedRowsCountForEmptySection = loggedNumberOfSections[1] else
        {
            fail("Should be able to determine row count for empty section")
            return
        }
        
        expect(loggedRowsCountForEmptySection).to(equal(Optional(0)))
    }
}
