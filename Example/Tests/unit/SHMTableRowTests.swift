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

class SHMTableRowTests: XCTestCase
{
    func test__callingInitWithAction__willSetAction()
    {
        var actionWasCalledWithIndexPath: IndexPath? = nil
        
        let row = SHMTableRow<LoggingTableViewCell>(model: "Test", action: { indexPath in
        
            actionWasCalledWithIndexPath = indexPath
            
        })
        
        let expectedIndexPath = IndexPath(row: 0, section: 0)
        
        row.action?(expectedIndexPath)
        
        expect(actionWasCalledWithIndexPath).to(equal(expectedIndexPath))
    }
    
    func test__rowsOfSameInstances__willEqual()
    {
        let row = SHMTableRow<LoggingTableViewCell>(model: "Test")
        
        expect(row.isEqual(to: row)).to(beTrue())
    }
    
    func test__rowsOfdifferentTypes__willNotEqual()
    {
        let row = SHMTableRow<LoggingTableViewCell>(model: "Test")
        
        expect(row.isEqual(to: "String is not of type SHMTableRow")).to(beFalse())
    }
    
    func test__rowsWithDifferentReusableIdentifiers__willNotEqual()
    {
        let rowA = SHMTableRow<LoggingTableViewCell>(model: "Test")
        let rowB = SHMTableRow<LoggingTableViewCell>(model: "Test", reusableIdentifier: "LoggingTableViewCell2")
        
        expect(rowA.isEqual(to: rowB)).to(beFalse())
    }
}
