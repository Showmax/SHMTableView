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
import UIKit

// MARK: - Editing

class SHMTableViewTestsEditing: LoggingTableTestCase {
    let logger = EditableTableViewCallLogger()
    
    override func setUp() {
        super.setUp()
      
        self.viewController?.shmTable.editingDelegate = logger
    }
    
    func test__afterEnablingEditing__dataSourceMethodsAreCalled() {
        ensureTableWillDisplay([
            createSection(name: "A", rowCount: 10),
            createSection(name: "B", rowCount: 10),
            createSection(name: "C", rowCount: 10)
        ])
        
        self.viewController?.shmTable.setEditing(true, animated: false)
        
        expect(self.logger.editingStyleForRowDidCall).to(beTrue())
        expect(self.logger.canEditRowDidCall).to(beTrue())
        expect(self.logger.canMoveRowDidCall).to(beTrue())
    }
}

class EditableTableViewCallLogger: SHMTableViewEditingDelegate {
    var editingStyleForRowDidCall: Bool = false
    var commitEditingStyleDidCall: Bool = false
    var moveRowAtDidCall: Bool = false
    var canEditRowDidCall: Bool = false
    var canMoveRowDidCall: Bool = false
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        editingStyleForRowDidCall = true
        
        return .none
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        commitEditingStyleDidCall = true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        moveRowAtDidCall = true
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        canEditRowDidCall = true
        
        return true
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        canMoveRowDidCall = true
        
        return true
    }
}
