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

open class SHMTableViewController: UIViewController {
    /// SHMTableView will manage mapping of models to certain view type (model to UITableViewCell subclass types).
    public var shmTable: SHMTableView!
    
#if os(iOS)
    /// SHMTableViewKeyboardVisibilityHandler that will resize tableView's bottom contentInset when keyboard is visible.
    public var shmTableKeyboardVisibilityHandler: SHMTableViewKeyboardVisibilityHandler?
#endif
    
    /// SHMTableViewForceTouchHandler that registers force touch handlers for given tableView.
    public var shmTableViewForceTouchHandler: SHMTableViewForceTouchHandler?
    
    /// Custom closure determining action on peeking event
    public var didPeek: ((IndexPath) -> UIViewController?)?
    {
        didSet {
            shmTableViewForceTouchHandler?.didPeek = didPeek
        }
    }
    
    /// Closure determining pop (the hard force touch) when peeking
    public var didPop: ((UIViewController) -> Void)? {
        didSet {
            shmTableViewForceTouchHandler?.didPop = didPop
        }
    }
    
    
    /// TableView to use to init for SHMTableView
    @IBOutlet open weak var tableView: UITableView! {
        didSet {
            // Create SHMTableView that will manage mapping of models to certain view type (model to UITableViewCell subclass types).
            shmTable = SHMTableView(tableView: tableView)

        #if os(iOS)
            // Create SHMTableViewKeyboardVisibilityHandler that will resize tableView's bottom contentInset when keyboard is shown.
            shmTableKeyboardVisibilityHandler = SHMTableViewKeyboardVisibilityHandler(tableView: tableView)
        #endif
        }
    }
    
    // MARK: - View Controller Lifecycle
    
    override open func viewDidLoad()
    {
        super.viewDidLoad()
        
        // We register our controller for 3D Touch events only if 3DTouch is available.
        if self.traitCollection.forceTouchCapability == .available {
            shmTableViewForceTouchHandler = SHMTableViewForceTouchHandler(
                parentViewController: self,
                tableView: tableView
            )
            
            shmTableViewForceTouchHandler?.register()
        }
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
    #if os(iOS)
        shmTableKeyboardVisibilityHandler?.start()
    #endif
    }
    
    override open func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        
    #if os(iOS)
        shmTableKeyboardVisibilityHandler?.stop()
    #endif
    }
}
