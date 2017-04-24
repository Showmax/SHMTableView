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
import SHMTableView

class LoggingTableViewCell: UITableViewCell, SHMConfigurableRow
{
    typealias T = String
    
    #if os(tvOS)
    static let reusableIdentifier = "LoggingTableViewCell+tvOS"
    #else
    static let reusableIdentifier = "LoggingTableViewCell"
    #endif
    
    @IBOutlet var label: UILabel!
    
    var configureMethodWasCalled: Bool = false
    var configureAtWillDisplayMethodWasCalled: Bool = false
    var configureOnHideMethodWasCalled: Bool = false
    
    func configure(_ model: T)
    {
        configureMethodWasCalled = true
    }
    
    func configureAtWillDisplay(_ model: T)
    {
        label.text = model
        
        configureAtWillDisplayMethodWasCalled = true
    }
    
    func configureOnHide(_ model: T)
    {
        configureOnHideMethodWasCalled = true
    }
}
