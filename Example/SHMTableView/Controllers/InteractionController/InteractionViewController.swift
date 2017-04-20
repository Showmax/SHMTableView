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
 
 This controller is about to teach you how to use table inside a cell.
 
 */

class InteractionViewController: SHMTableViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // create interaction section and add a row
        let interactionSection = SHMTableSection()
        
        shmTable += interactionSection
        
        /**
         
         Most of the code here is just about UIAlertController. If you need to catch a tap on a row, you can use 
         
         public convenience init(model: cell.T, reusableIdentifier: String? = nil, action: ((IndexPath) -> (Void))? = nil)
         
         If you'd like to catch a tap on any UI elemen then the best way to do that is by defyning a closure within your model
         (see definition of InteractionModel).
         
         */
        
        interactionSection += SHMTableRow<InteractionTableViewCell>(model: InteractionModel(buttonAction: { [weak self] _ in
        
            guard let me = self else
            {
                return
            }
            
            let alertController = UIAlertController(
                title: "Interaction with Button",
                message: "You've just pressed a button in a cell.",
                preferredStyle: .alert
            )
            
            alertController.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
            
            me.present(alertController, animated: true, completion: nil)
        
        }), action: { [weak self] indexPath in
        
            guard let me = self else
            {
                return
            }
            
            let alertController = UIAlertController(
                title: "Interaction with Row",
                message: "You've just pressed a cell at \(indexPath).",
                preferredStyle: .alert
            )

            alertController.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))

            me.present(alertController, animated: true, completion: nil)
            
        })
    }
}
