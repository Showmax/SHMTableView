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

 Generic section of the SHMTableView.
 
 It supports both header & footer and both title & view based.
 
 */

public protocol SHMTableViewProtocol: class {
    func configure() -> UIView
    func associatedView() -> UIView
}

/**
 
 Class mapping section custom header view type with instances of model and custom view.
 
 */
public class SHMTableHeader<View: SHMConfigurable>: SHMTableViewProtocol where View: UIView {
    /// Holds instance of model
    var model: View.T
    
    /// Holds instance of view
    var view: UIView
    
    public init(model: View.T, view: UIView) {
        self.model = model
        self.view = view
    }
    
    /// Will try to configure view with model
    public func configure() -> UIView {
        (view as? View)?.configure(model)
        
        return view
    }

    public func associatedView() -> UIView {
        return view
    }
}

/**
 
 Class mapping section custom footer view type with instances of model and custom view.
 
 */
public class SHMTableFooter<View: SHMConfigurable>: SHMTableViewProtocol where View: UIView {
    /// Holds instance of model
    var model: View.T
    
    /// Holds instance of view
    var view: UIView
    
    public init(model: View.T, view: UIView) {
        self.model = model
        self.view = view
    }
    
    /// Will try to configure view with model
    public func configure() -> UIView {
        (view as? View)?.configure(model)
        
        return view
    }
    
    public func associatedView() -> UIView {
        return view
    }
}

/**
 
 Defines section information including identifier, header, footer and all subordinate rows.
 
 */
public class SHMTableSection {
    /// Optional. Used for better distinguishing between other sections. Specifying make diffing faster.
    public var identifier: String? = nil
    
    /// Optional. Title for header
    public var headerTitle: String? = nil
    
    /// Optional. Title for footer
    public var footerTitle: String? = nil

    /// Optional. View for header
    public var headerView: SHMTableViewProtocol? = nil
    
    /// Optional. View for footer
    public var footerView: SHMTableViewProtocol? = nil

    /// Subordinate rows
    public var rows: [SHMTableRowProtocol]
    
    public init() {
        rows = []
    }
    
    /// Rows can be specified via constructor
    public convenience init(rows: [SHMTableRowProtocol]) {
        self.init()
        
        self.rows = rows
    }

    /// Appends row to current section row.
    public func append(row: SHMTableRowProtocol) {
        rows.append(row)
    }
}

extension SHMTableSection: SHMDiffable {
    public func isEqual(to other: SHMDiffable) -> Bool {
        // not equal if other object is of different type
        guard let other = other as? SHMTableSection else { return false }
        
        // equal if both objects are same instance
        guard self !== other else { return true }
        
        // equal if all important properties are equal
        return  identifier == other.identifier &&
                headerTitle == other.headerTitle &&
                footerTitle == other.footerTitle &&
                headerView === other.headerView &&
                footerView === other.footerView &&
                areRowsEqualTo(to: other.rows)
    }
    
    private func areRowsEqualTo(to otherRows: [SHMTableRowProtocol]?) -> Bool {
        // not equal if rows count is different
        guard   let otherRows = otherRows,
                rows.count == otherRows.count
                else {
            return false
        }
        
        // not equal if found at least one not equal row (or order changed)
        for i in 0..<otherRows.count where !rows[i].isEqual(to: otherRows[i]) {
            return false
        }
        
        return true
    }
}
