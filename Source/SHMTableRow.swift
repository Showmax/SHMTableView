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
 
 Generic row of the SHMTableView.
 
 */

public class SHMTableRow<cell: SHMConfigurableRow>: SHMTableRowProtocol where cell: UITableViewCell
{
    /// Holds model paired with view type
    var model: cell.T
 
    /// Optional. If specified, bundle will be used for loading NIBs in SHMTableView.register(row:)
    public var bundle: Bundle?
    
    /// Optional. Primary row action used when tapped on row
    private var _action: ((IndexPath) -> Void)? = nil
    public var action: ((IndexPath) -> Void)?
    {
        get { return _action }
        set { _action = newValue }
    }
 
    /// Reusable identifier indentifies view cell after it is registered to SHMTableView or UITableView
    private var _reusableIdentifier: String
    public var reusableIdentifier: String
    {
        get { return _reusableIdentifier }
    }
    
    /// Setup model and define reusable identifier based on cell type
    ///
    /// - Parameter model: instance of model
    public init(model: cell.T)
    {
        self.model = model
        self._reusableIdentifier = String(describing: cell.self)
    }
    
    /// Setup model and define reusable identifier based on cell type. Also setup action and custom reusable identifier
    ///
    /// - Parameter model: instance of model
    /// - Parameter reusableIdentifier: optional, custom reusable identifier key
    /// - Parameter action: optional, primary row action used when tapped on row
    public convenience init(model: cell.T, reusableIdentifier: String? = nil, action: ((IndexPath) -> (Void))? = nil)
    {
        self.init(model: model)
        
        self.action = action
        
        if let reusableIdentifier = reusableIdentifier
        {
            self._reusableIdentifier = reusableIdentifier
        }
    }
    
    /// Will try to call configure on given tableViewCell
    public func configure(tableViewCell: UITableViewCell)
    {
        (tableViewCell as? cell)?.configure(model)
    }

    /// Will try to call configureAtWillDisplay on given tableViewCell
    public func configureAtWillDisplay(tableViewCell: UITableViewCell)
    {
        (tableViewCell as? cell)?.configureAtWillDisplay(model)
    }
}

// MARK: - SHMDiffable

extension SHMTableRow
{
    public func isEqual(to other: SHMDiffable) -> Bool
    {
        // not equal if other object is of different type
        guard let other = other as? SHMTableRow else { return false }
        
        // equal if both objects are same instance
        guard self !== other else { return true }
        
        // not equal if reusable identifier differs
        guard reusableIdentifier == other.reusableIdentifier else { return false }
        
        // not equal if both models are JFDiffable and are not equal
        if  let modelDiffable = model as? SHMDiffable,
            let otherModelDiffable = other.model as? SHMDiffable,
            !modelDiffable.isEqual(to: otherModelDiffable)
        {
            return false
        }
        
        return true
    }
}

