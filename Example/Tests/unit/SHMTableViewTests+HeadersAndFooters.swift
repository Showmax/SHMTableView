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

#if os(tvOS)
let testHeaderNIBName = "ShowMaxHeader+tvOS"
#else
let testHeaderNIBName = "ShowMaxHeader"
#endif

// MARK: - Headers and Footers

extension SHMTableViewTests
{
    func test__definedHeaderView__isUsedByTableView()
    {
        let section = createSection(name: "A", rowCount: 100)
        
        let nib = UINib(nibName: testHeaderNIBName, bundle: Bundle(for: type(of: self)))
        if let view = nib.instantiate(withOwner: nil, options: nil)[0] as? UIView
        {
            section.headerView = SHMTableHeader<MainControllerHeaderCell>(model: "", view: view)
        }
        
        ensureTableWillDisplay([section])
        
        guard let loggedHeaderView = viewController?.shmTable.loggedSectionHeaderViews[0] else
        {
            fail("Table data source should receive defined section header view")
            return
        }
        
        expect(loggedHeaderView).to(equal(section.headerView?.associatedView()))
    }
    
    func test__definedFooterView__isUsedByTableView()
    {
        let section = createSection(name: "A", rowCount: 1)
        
        let nib = UINib(nibName: testHeaderNIBName, bundle: Bundle(for: type(of: self)))
        if let view = nib.instantiate(withOwner: nil, options: nil)[0] as? UIView
        {
            section.footerView = SHMTableFooter<MainControllerHeaderCell>(model: "", view: view)
        }
        
        ensureTableWillDisplay([section])
        
        guard let loggedFooterView = viewController?.shmTable.loggedSectionFooterViews[0] else
        {
            fail("Table data source should receive defined section footer view")
            return
        }
        
        expect(loggedFooterView).to(equal(section.footerView?.associatedView()))
    }
    
    func test__definedHeaderTitle__isUsedByTableView()
    {
        let section = createSection(name: "A", rowCount: 100)
        section.headerTitle = "Test header title"
        
        ensureTableWillDisplay([section])
        
        guard let loggedHeaderTitle = viewController?.shmTable.loggedSectionHeaderTitles[0] else
        {
            fail("Table data source should receive defined section header title")
            return
        }
        
        expect(loggedHeaderTitle).to(equal(section.headerTitle))
    }
    
    func test__definedFooterTitle__isUsedByTableView()
    {
        let section = createSection(name: "A", rowCount: 100)
        section.footerTitle = "Test footer title"
        
        ensureTableWillDisplay([section])
        
        guard let loggedFooterTitle = viewController?.shmTable.loggedSectionFooterTitles[0] else
        {
            fail("Table data source should receive defined section footer title")
            return
        }
        
        expect(loggedFooterTitle).to(equal(section.footerTitle))
    }
}
