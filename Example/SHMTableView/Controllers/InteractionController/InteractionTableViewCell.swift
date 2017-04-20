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

/**
 
 InteractionModel is just about a closure. 
 
 The most interesting logic is happening inside the @IBAction method.
 The method is basicaly doing a binding between an action and a closure by calling it.
 
 */


struct InteractionModel
{
    let buttonAction: () -> Void
}

class InteractionTableViewCell: UITableViewCell, SHMConfigurableRow
{
    typealias T = InteractionModel
    
    var cellAction: InteractionModel? = nil

    func configure(_ model: T)
    {
        self.cellAction = model
    }
    
    func configureAtWillDisplay(_ model: T)
    {
    }
    
    @IBAction func buttonPressed(sender: UIButton)
    {
        // the magic is happening here
        cellAction?.buttonAction()
    }
}
