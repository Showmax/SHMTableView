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
import Nimble
import SHMTableView

class SHMTableChangesFinderTests: XCTestCase {
    struct TestCase {
        var old: [SHMTableSection]
        var new: [SHMTableSection]
        var expectedChanges: SHMTableChangesFinderChanges

        init(old: [SHMTableSection] = [], new: [SHMTableSection] = [], expectedChanges: SHMTableChangesFinderChanges = SHMTableChangesFinderChanges()) {
            self.old = old
            self.new = new
            self.expectedChanges = expectedChanges
        }
    }
    
    var finder = SHMTableChangesFinder()
}


// MARK: - Basic

extension SHMTableChangesFinderTests {
    func test__identicalLists__haveEmptyChanges() {
        let t = TestCase(
            old: [
                createSection(name: "A", rowCount: 10),
                createSection(name: "B", rowCount: 15),
                createSection(name: "C", rowCount: 20)
            ],
            new: [
                createSection(name: "A", rowCount: 10),
                createSection(name: "B", rowCount: 15),
                createSection(name: "C", rowCount: 20)
            ]
        )
        
        assertExpectedChangesWereFound(t)
    }
    
    func test__comparingDifferentChanges__willNotEqual() {
        let a = SHMTableChangesFinderChanges()
        var b = SHMTableChangesFinderChanges()
        b.sectionsToDelete.insert(1)
        b.sectionsToInsert.insert(1)
        b.rowsToInsert.append(IndexPath(row: 0, section: 0))
        b.rowsToDelete.append(IndexPath(row: 0, section: 0))

        expect(a).toNot(equal(b))
    }
}


// MARK: - Measuring performance

extension SHMTableChangesFinderTests {
    func test__measure__findingChangesWhenInsertingAndDeletingRows() {
        measure {
            self.test__rowsInsertedAndDeletedInList__areMentionedInChanges()
        }
    }
}


// MARK: - Helpers

extension SHMTableChangesFinderTests {
    func assertExpectedChangesWereFound(_ testCase: TestCase) {
        let foundChanges = finder.find(betweenOld: testCase.old, andNew: testCase.new)
        expect(foundChanges).to(equal(testCase.expectedChanges))
    }
}
