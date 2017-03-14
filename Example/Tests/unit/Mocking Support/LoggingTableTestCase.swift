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

class LoggingTableTestCase: XCTestCase
{
    var viewController: LoggingViewController?
    
    override func setUp()
    {
        super.setUp()
        
        let testingBundle: Bundle? = Bundle(for: type(of: self))
        
        #if os(tvOS)
        let storyboardName = "LoggingStoryboard+tvOS"
        #else
        let storyboardName = "LoggingStoryboard"
        #endif
        
        let storyboard = UIStoryboard(name: storyboardName, bundle: testingBundle)
        
        guard   let navigationController = storyboard.instantiateInitialViewController() as? UINavigationController,
                let viewController = navigationController.topViewController as? LoggingViewController
                else
        {
            fail("Unable to initialize LoggingStoryboard")
            return
        }
        
        self.viewController = viewController
        
        expect(navigationController.view).notTo(beNil())
        expect(self.viewController?.view).notTo(beNil())
        
        // Specify where to look for NIBs. Required on testing target, otherwise testing module cannot find NIBs for used cells.
        self.viewController?.shmTable.defaultBundle = testingBundle
        
        // Triggers viewDidLoad(), viewWillAppear(), viewDidAppear() events.
        self.viewController?.beginAppearanceTransition(true, animated: false)
        self.viewController?.endAppearanceTransition()
        
        // Layout views (will also force table to layout its cells).
        self.viewController?.view.layoutIfNeeded()
    }
    
    func ensureTableWillDisplay(_ sections: [SHMTableSection])
    {
        // Will update table model and schedule UI updates in next UI refresh cycle
        self.viewController?.shmTable.update(withNewSections: sections)
        
        // Skip waiting for next UI refresh cycle
        self.viewController?.view.layoutIfNeeded()
    }
}
