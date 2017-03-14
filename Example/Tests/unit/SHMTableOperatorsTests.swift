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

class SHMTableOperatorsTests: LoggingTableTestCase
{
    func test__section__canBeAddedToTable()
    {
        let section = SHMTableSection()
        
        viewController?.shmTable += section
        
        expect(self.viewController?.shmTable.sections.last).to(beIdenticalTo(section))
    }
    
    func test__rowAddedToEmptyTable__willBeAddedToAutomaticallyCreatedSection()
    {
        let row = SHMTableRow<LoggingTableViewCell>(model: "Test row", reusableIdentifier: LoggingTableViewCell.reusableIdentifier)
        
        viewController?.shmTable += row
        
        expect(self.viewController?.shmTable.sections.first?.rows.last).to(beIdenticalTo(row))
    }
    
    func test__rowAddedToNonEmptyTable__willBeAddedToFirstSection()
    {
        let firstSection = SHMTableSection()
        let secondSection = SHMTableSection()
        viewController?.shmTable += firstSection
        viewController?.shmTable += secondSection
        
        let row = SHMTableRow<LoggingTableViewCell>(model: "Test row", reusableIdentifier: LoggingTableViewCell.reusableIdentifier)
        
        viewController?.shmTable += row
        
        expect(firstSection.rows.last).to(beIdenticalTo(row))
    }
    
    func test__row__canBeAddedToSection()
    {
        let row = SHMTableRow<LoggingTableViewCell>(model: "Test row", reusableIdentifier: LoggingTableViewCell.reusableIdentifier)
        let section = SHMTableSection()
        
        section += row
        
        expect(section.rows.last).to(beIdenticalTo(row))
    }
    
    func test__arrayOfRows__canBeAddedToSection()
    {
        let rows = [
            SHMTableRow<LoggingTableViewCell>(model: "Test row", reusableIdentifier: LoggingTableViewCell.reusableIdentifier),
            SHMTableRow<LoggingTableViewCell>(model: "Test row", reusableIdentifier: LoggingTableViewCell.reusableIdentifier),
            SHMTableRow<LoggingTableViewCell>(model: "Test row", reusableIdentifier: LoggingTableViewCell.reusableIdentifier)
        ]
        let section = SHMTableSection()
    
        let initialNumberOfRows = section.rows.count
        
        section += rows
        
        for (index, row) in rows.enumerated()
        {
            expect(section.rows[initialNumberOfRows + index]).to(beIdenticalTo(row))
        }
    }
    
    
}
