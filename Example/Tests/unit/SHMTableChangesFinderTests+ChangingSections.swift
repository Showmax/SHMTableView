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

// MARK: - Sections

extension SHMTableChangesFinderTests {
    func test__sectionAppendedToEndOfList__isMentionedInChanges() {
        var t = TestCase(
            old: [
                createSection(name: "A", rowCount: 10),
                createSection(name: "B", rowCount: 15),
                createSection(name: "C", rowCount: 20)
            ],
            new: [
                createSection(name: "A", rowCount: 10),
                createSection(name: "B", rowCount: 15),
                createSection(name: "C", rowCount: 20),
                createSection(name: "inserted after section C", rowCount: 15)
            ]
        )
        t.expectedChanges.sectionsToInsert.insert(3)
        
        assertExpectedChangesWereFound(t)
    }
    
    func test__sectionsAppendedToList__areMentionedInChanges() {
        var t = TestCase(
            old: [
                createSection(name: "A", rowCount: 10),
                createSection(name: "B", rowCount: 10),
                createSection(name: "C", rowCount: 10)
            ],
            new: [
                createSection(name: "A", rowCount: 10),
                createSection(name: "B", rowCount: 10),
                createSection(name: "new after section B", rowCount: 10),
                createSection(name: "C", rowCount: 10),
                createSection(name: "new after section C", rowCount: 10)
            ]
        )
        t.expectedChanges.sectionsToInsert = IndexSet([2, 4])
        
        assertExpectedChangesWereFound(t)
    }
    
    func test__sectionsDeletedFromList__areMentionedInChanges() {
        var t1 = TestCase(
            old: [
                createSection(name: "A", rowCount: 10),
                createSection(name: "B", rowCount: 10), // will be deleted
                createSection(name: "C", rowCount: 10), // will be deleted
                createSection(name: "D", rowCount: 10)
            ],
            new: [
                createSection(name: "A", rowCount: 10),
                createSection(name: "D", rowCount: 10)
            ]
        )
        t1.expectedChanges.sectionsToDelete = IndexSet([1, 2])
        
        var t2 = TestCase(
            old: [
                createSection(name: "A", rowCount: 10), // will be deleted
                createSection(name: "B", rowCount: 10),
                createSection(name: "C", rowCount: 10), // will be deleted
                createSection(name: "D", rowCount: 10),
                createSection(name: "E", rowCount: 10), // will be deleted
                createSection(name: "F", rowCount: 10)
            ],
            new: [
                createSection(name: "B", rowCount: 10),
                createSection(name: "D", rowCount: 10),
                createSection(name: "F", rowCount: 10)
            ]
        )
        t2.expectedChanges.sectionsToDelete = IndexSet([0, 2, 4])
        
        for t in [t1, t2] {
            assertExpectedChangesWereFound(t)
        }
    }
    
    func test__sectionsInsertedAndDeletedInList__areMentionedInChanges() {
        var t = TestCase(
            old: [
                createSection(name: "A", rowCount: 10), // will be deleted
                createSection(name: "B", rowCount: 10),
                createSection(name: "C", rowCount: 10), // will be deleted
                createSection(name: "D", rowCount: 10),
                createSection(name: "E", rowCount: 10), // will be deleted
                createSection(name: "F", rowCount: 10)
            ],
            new: [
                createSection(name: "new before section B", rowCount: 10),
                createSection(name: "B", rowCount: 10),
                createSection(name: "new after section B", rowCount: 10),
                createSection(name: "new before section D", rowCount: 10),
                createSection(name: "D", rowCount: 10),
                createSection(name: "F", rowCount: 10),
                createSection(name: "new after section F", rowCount: 10)
            ]
        )
        t.expectedChanges.sectionsToDelete = IndexSet([0, 2, 4])
        t.expectedChanges.sectionsToInsert = IndexSet([0, 2, 3, 6])
        
        assertExpectedChangesWereFound(t)
        
    }
}
