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
 
 This controller is just wrapping a typical UIViewController and helps you to focus just on the business logic.
 
 You can instantiate SHMTableView whatever way you want, but don't forget to connect it with a UITableView.
 
 */

open class SHMTableViewController: UIViewController
{
    /// SHMTableView, which is always available in our Controller
    public var shmTable: SHMTableView!
    
    /// Force touch handler, that registers any SHMTableView for 3D touch events.
    public var forceTouchHandle: SHMForceTouchHandler?
    
    /// TableView to use to init for SHMTableView
    @IBOutlet open weak var tableView: UITableView!
    {
        didSet
        {
            // here is the meat
            shmTable = SHMTableView(tableView: tableView)
        }
    }
    
    open override func viewDidLoad() 
    {
        
     // We register our controller for 3D Touch events only if 3DTouch is available.
        if self.traitCollection.forceTouchCapability == .available
        {
        
            forceTouchHandle = SHMForceTouchHandler(
                dependencies: SHMForceTouchHandler.ForceTouchDependencies(
                parentViewController: self,
                shmTableView: shmTable
                )
            )
            
            forceTouchHandle?.register()
        }
    }
    
}
