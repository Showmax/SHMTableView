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

import UIKit

/**

 Set of usefull operators.
 
 */


/**

 Add a section into a table by this one.
 
 If you'd like to add a collection of sections, use the SHMTableView's method
 
 public func update(
    withNewSections newSections: [SHMTableSection], 
    rowAnimation: UITableViewRowAnimation = .fade, 
    forceReloadData: Bool = false
 )
 
 instead.
 
 */
public func += (left: SHMTableView, right: SHMTableSection) {
    left.append(section: right)
}

/// Add a row into a table by this one. It automatically handle the business logic behind sections.
public func += (left: SHMTableView, right: SHMTableRowProtocol) {
    let section: SHMTableSection
    
    if left.sections.isEmpty {
        section = SHMTableSection()

        left.append(section: section)
        
    } else {
        section = left.sections[0]
    }
    
    section += right
}

/// Add a row into a section by this one.
public func += (left: SHMTableSection, right: SHMTableRowProtocol) {
    left.rows.append(right)
}

/// Add a collection of rows into a section by this one.
public func += (left: SHMTableSection, right: [SHMTableRowProtocol]) {
    left.rows.append(contentsOf: right)
}
