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

/**

 Holding all changes information found by SHMTableChangesFinder while comparing two lists of sections.
 
 */
public struct SHMTableChangesFinderChanges: Equatable {
    public var sectionsToDelete = IndexSet()
    public var sectionsToInsert = IndexSet()
    public var sectionsToReload = IndexSet()
    public var sectionsToMove = [(from: Int, to: Int)]()
    public var rowsToDelete = [IndexPath]()
    public var rowsToInsert = [IndexPath]()
    public var rowsToReload = [IndexPath]()
    public var rowsToMove = [(from: IndexPath, to: IndexPath)]()
    
    public init() {}
    
    public static func == (lhs: SHMTableChangesFinderChanges, rhs: SHMTableChangesFinderChanges) -> Bool {
        return  lhs.sectionsToDelete == rhs.sectionsToDelete &&
                lhs.sectionsToInsert == rhs.sectionsToInsert &&
                lhs.sectionsToReload == rhs.sectionsToReload &&
                lhs.rowsToDelete == rhs.rowsToDelete &&
                lhs.rowsToInsert == rhs.rowsToInsert &&
                lhs.rowsToReload == rhs.rowsToReload &&
                lhs.sectionsToMove.count == rhs.sectionsToMove.count &&
                lhs.rowsToMove.count == rhs.rowsToMove.count
    }
}

/**
 
 Method find will try to find changes between previous sections and new sections.
 
 */
public class SHMTableChangesFinder {
    public init() {}

    /// Find changes between given old and new sections and theirs nested rows
    /// 
    /// Internally uses algorithm derived from Jack Flinterman Dwifft. First will compare which sections to delete and which to insert.
    /// If some sections would be both inserted and deleted then we assume they should be reloaded instead. For each section to be 
    /// reloaded we compare their rows and determine which to delete and which to insert. 
    ///
    /// - Parameter oldSection: sections considered as old/initial
    /// - Parameter newSection: sections that will replace old sections
    /// - Returns: Changed rows and sections
    public func find(betweenOld oldSections: [SHMTableSection], andNew newSections: [SHMTableSection]) -> SHMTableChangesFinderChanges {
        var changes = SHMTableChangesFinderChanges()
        
        let sectionsDiff = JFLCSDiff.diff(a: oldSections, b: newSections)
        
        // section to delete and insert
        sectionsDiff.deletions.forEach { changes.sectionsToDelete.insert($0.idx) }
        sectionsDiff.insertions.forEach { changes.sectionsToInsert.insert($0.idx) }
        
        // sections to reload (will ensure viewForHeaderInSection is called)
        let candidateSectionsToReload = changes.sectionsToDelete.intersection(changes.sectionsToInsert)
        
        // rows updates for reloaded sections
        for reloadIndex in candidateSectionsToReload {
            guard   reloadIndex < oldSections.count,
                    reloadIndex < newSections.count
                    else {
                continue
            }
            
            let oldSection = oldSections[reloadIndex]
            let newSection = newSections[reloadIndex]
            let oldRows = oldSection.rows
            let newRows = newSection.rows
            
            
            // do not reload section if header view models is still same, we wont reload section unnecessary blinking
            guard   newSection.identifier == oldSection.identifier,
                    newSection.headerTitle == oldSection.headerTitle,
                    newSection.footerTitle == oldSection.footerTitle,
                    newSection.headerView === oldSection.headerView,
                    newSection.footerView === oldSection.footerView
                    else {
                continue
            }
            
            changes.sectionsToInsert.remove(reloadIndex)
            changes.sectionsToDelete.remove(reloadIndex)
            
            let rowsDiff = JFLCSDiff.diff(a: oldRows, b: newRows)
            
            // rows to delete and insert
            var deletionRows = IndexSet()
            var insertionRows = IndexSet()
            rowsDiff.deletions.forEach { deletionRows.insert($0.idx) }
            rowsDiff.insertions.forEach { insertionRows.insert($0.idx) }
            
            // create index paths
            deletionRows.forEach { changes.rowsToDelete.append(IndexPath(item: $0, section: reloadIndex)) }
            insertionRows.forEach { changes.rowsToInsert.append(IndexPath(item: $0, section: reloadIndex)) }
        }
        
        return changes
    }
}
