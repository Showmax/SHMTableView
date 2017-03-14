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

// MARK: - Rows

extension SHMTableChangesFinderTests
{
    func test__rowsInsertedToList__areMentionedInChanges()
    {
        var t = TestCase(
            old: [
                createSection(name: "A", rowCount: 10),
                createSection(name: "B", rows: [
                    "1",
                    "2",
                    "3",
                    "4"
                ]),
                createSection(name: "C", rowCount: 10)
            ],
            new: [
                createSection(name: "A", rowCount: 10),
                createSection(name: "B", rows: [
                    "1",
                    "2",
                    "3",
                    "new after former row 3",
                    "4",
                    "new after former row 4"
                ]),
                createSection(name: "C", rowCount: 10),
            ]
        )
        t.expectedChanges.rowsToInsert.append(IndexPath(row: 3, section: 1))
        t.expectedChanges.rowsToInsert.append(IndexPath(row: 5, section: 1))
        
        assertExpectedChangesWereFound(t)
    }
    
    func test__rowsDeletedFromList__areMentionedInChanges()
    {
        var t = TestCase(
            old: [
                createSection(name: "A", rowCount: 10),
                createSection(name: "B", rows: [
                    "1",
                    "2", // will be deleted
                    "3",
                    "4",
                    "5", // will be deleted
                    "6",
                    "7",
                    "8", // will be deleted
                    "9"
                ]),
                createSection(name: "C", rowCount: 10)
            ],
            new: [
                createSection(name: "A", rowCount: 10),
                createSection(name: "B", rows: [
                    "1",
                    "3",
                    "4",
                    "6",
                    "7",
                    "9"
                ]),
                createSection(name: "C", rowCount: 10),
            ]
        )
        t.expectedChanges.rowsToDelete.append(IndexPath(row: 1, section: 1))
        t.expectedChanges.rowsToDelete.append(IndexPath(row: 4, section: 1))
        t.expectedChanges.rowsToDelete.append(IndexPath(row: 7, section: 1))
        assertExpectedChangesWereFound(t)
    }
    
    func test__rowsInsertedAndDeletedInList__areMentionedInChanges()
    {
        var testCases: [TestCase] = []
        
        var t = TestCase(
            old: [
                createSection(name: "A", rowCount: 10),
                createSection(name: "B", rows: [
                    "1",
                    "2", // will be deleted
                    "3",
                    "4",
                    "5", // will be deleted
                    "6",
                    "7",
                    "8", // will be deleted
                    "9"
                ]),
                createSection(name: "C", rowCount: 10)
            ],
            new: [
                createSection(name: "A", rowCount: 10),
                createSection(name: "B", rows: [
                    "1",
                    "inserted after former row 1",
                    "3",
                    "inserted after former row 3",
                    "4",
                    "6",
                    "inserted after former row 3",
                    "7",
                    "9"
                ]),
                createSection(name: "C", rowCount: 10)
            ]
        )
        t.expectedChanges.rowsToDelete.append(IndexPath(row: 1, section: 1))
        t.expectedChanges.rowsToDelete.append(IndexPath(row: 4, section: 1))
        t.expectedChanges.rowsToDelete.append(IndexPath(row: 7, section: 1))
        t.expectedChanges.rowsToInsert.append(IndexPath(row: 1, section: 1))
        t.expectedChanges.rowsToInsert.append(IndexPath(row: 3, section: 1))
        t.expectedChanges.rowsToInsert.append(IndexPath(row: 6, section: 1))
        
        assertExpectedChangesWereFound(t)
    }
    
    func test__rowsWithIdenticalValuesDeletedInList__areMentionedInChanges()
    {
        var t = TestCase(
            old: [
                createSection(name: "A", rows: [
                    "A row",
                    "A row", // will be deleted
                    "A row",
                    "A row", // will be deleted
                    "A row",
                    "A row", // will be deleted
                ]),
            ],
            new: [
                createSection(name: "A", rows: [
                    "A row",
                    "A row",
                    "A row",
                ]),
            ]
        )
        t.expectedChanges.rowsToDelete.append(IndexPath(row: 3, section: 0))
        t.expectedChanges.rowsToDelete.append(IndexPath(row: 4, section: 0))
        t.expectedChanges.rowsToDelete.append(IndexPath(row: 5, section: 0))
        
        assertExpectedChangesWereFound(t)
    }
    
    func test__emptySectionThatIsFilledWithRows__isMentionedInChanges()
    {
        var t = TestCase(
            old: [
                createSection(name: "A", rowCount: 10),
                createSection(name: "B", rowCount: 0),
                createSection(name: "C", rowCount: 10),
                createSection(name: "D", rowCount: 10)
            ],
            new: [
                createSection(name: "A", rowCount: 10),
                createSection(name: "B", rowCount: 3),
                createSection(name: "C", rowCount: 10),
                createSection(name: "D", rowCount: 10)
            ]
        )
        t.expectedChanges.rowsToInsert.append(IndexPath(row: 0, section: 1))
        t.expectedChanges.rowsToInsert.append(IndexPath(row: 1, section: 1))
        t.expectedChanges.rowsToInsert.append(IndexPath(row: 2, section: 1))
        
        assertExpectedChangesWereFound(t)
    }

    func test__identicalInstances__notMentionedInChanges()
    {
        let row = SHMTableRow<LoggingTableViewCell>(model: "A row")
        let section = createSection(name: "A")
        section.rows = [row, row, row, row]
        
        var t = TestCase(
            old: [
                section,
                section,
                createSection(name: "B", rowCount: 0),
                createSection(name: "C", rowCount: 10),
                createSection(name: "D", rowCount: 10)
            ],
            new: [
                section,
                section,
                createSection(name: "B", rowCount: 3),
                createSection(name: "C", rowCount: 10),
                createSection(name: "D", rowCount: 10)
            ]
        )
        t.expectedChanges.rowsToInsert.append(IndexPath(row: 0, section: 2))
        t.expectedChanges.rowsToInsert.append(IndexPath(row: 1, section: 2))
        t.expectedChanges.rowsToInsert.append(IndexPath(row: 2, section: 2))
        
        assertExpectedChangesWereFound(t)
    }
}
