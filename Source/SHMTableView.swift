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
 
 Protocol consist of UITableView methods that are related table editing mode.
 If you need to handle table editing mode, you should implement it.
 
 */
public protocol SHMTableViewEditingDelegate: class
{
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool
}


/**
 
 The heart of the module.
 
 SHMTableView is wrapper over UITableView datasource, that help you
 define table content just by mapping view types to model instances.
 
 SHMTableView is here to take you away from a routine stuff of UITableViewDataSource and UITableViewDelegate.
 Instead you just focus on a structure and a content to be displayed by a UITableView.
 
 */
public class SHMTableView: NSObject, UITableViewDelegate, UITableViewDataSource
{
    /// Optional. Delegate for table in editing mode
    open weak var editingDelegate: SHMTableViewEditingDelegate?
    
    /// Optional. If specified, bundle will be used for loading NIBs in SHMTableView.register(row:)
    open var defaultBundle: Bundle?
    
    /// Managed table view
    open fileprivate(set) weak var tableView: UITableView?
    
    /// Currently managed sections to be displayed (or that already are displayed if UITableView finished loading)
    open fileprivate(set) var sections = [SHMTableSection]()
    
    /// Map with registered NIBs identifiers to prevent registering same identifier twice
    public fileprivate(set) var registeredNibs = [String]()
    
    /// Search for differences between two lists of sections
    fileprivate var changesFinder: SHMTableChangesFinder
        
    /// For given table view will setup delegate, datasource, row automatic height, estimatedRowHeight.
    public init(tableView: UITableView)
    {
        self.changesFinder = SHMTableChangesFinder()
        
        super.init()
        
        self.tableView = tableView
        
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.tableView?.rowHeight = UITableViewAutomaticDimension
        self.tableView?.estimatedRowHeight = 44.0
    }

    
    // MARK: - Updating model

    /// Appends section to local list of sections
    public func append(section: SHMTableSection)
    {
        sections.append(section)
    }
    
    /// First will try to find changes between new given sections and between currently shown sections.
    /// 
    /// Question is when to call reloadData and when reload table view via batch animations.
    /// Table view reload data is called when user use force flag, or when all currently visible 
    /// sections are about to be deleted. In other cases will try do batch section+rows animations
    ///
    public func update(
        withNewSections newSections: [SHMTableSection],
        rowAnimation: UITableViewRowAnimation = .fade,
        forceReloadData: Bool = false
        )
    {
        let changes = changesFinder.find(betweenOld: sections, andNew: newSections)
        
        sections = newSections
        
        if forceReloadData || allCurrentlyVisibleSectionsAboutToBeDeleted(with: changes.sectionsToDelete)
        {
            reloadDataAll()
            
        } else
        {
            reloadDataJustChanges(changes, rowAnimation: rowAnimation)
        }
    }
    
    /// Call full table view reload
    internal func reloadDataAll()
    {
        tableView?.reloadData()
    }
    
    /// Call batch table view reloads
    internal func reloadDataJustChanges(_ changes: SHMTableChangesFinderChanges, rowAnimation: UITableViewRowAnimation)
    {
        tableView?.beginUpdates()
        
        if !changes.sectionsToDelete.isEmpty
        {
            tableView?.deleteSections(changes.sectionsToDelete, with: rowAnimation)
        }
        
        if !changes.sectionsToInsert.isEmpty
        {
            tableView?.insertSections(changes.sectionsToInsert, with: rowAnimation)
        }
        
        if !changes.rowsToDelete.isEmpty
        {
            tableView?.deleteRows(at: changes.rowsToDelete, with: rowAnimation)
        }
        
        if !changes.rowsToInsert.isEmpty
        {
            tableView?.insertRows(at: changes.rowsToInsert, with: rowAnimation)
        }
        
        tableView?.endUpdates()
    }

    
    // MARK: - Handling Editing Mode

    /// Turning on/off table view editing mode
    public func setEditing(_ editing: Bool, animated: Bool)
    {
        tableView?.setEditing(editing, animated: animated)
    }

    // MARK: Data manipulation
    
    /// Forward call to editingDelegate
    public func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle
    {
        return editingDelegate?.tableView(tableView, editingStyleForRowAt: indexPath) ?? .none
    }
    
    /// Forward call to editingDelegate
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        editingDelegate?.tableView(tableView, commit: editingStyle, forRowAt: indexPath)
    }
    
    /// Forward call to editingDelegate, but also will update currently held sections structure.
    public func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
    {
        guard   sourceIndexPath.section < sections.count,
                destinationIndexPath.section < sections.count,
                sourceIndexPath.row < sections[sourceIndexPath.section].rows.count,
                destinationIndexPath.row < sections[destinationIndexPath.section].rows.count
                else
        {
            return
        }
        
        let element = sections[sourceIndexPath.section].rows[sourceIndexPath.row]
        
        sections[sourceIndexPath.section].rows.remove(at: sourceIndexPath.row)
        sections[destinationIndexPath.section].rows.insert(element, at: destinationIndexPath.row)
        
        editingDelegate?.tableView(tableView, moveRowAt: sourceIndexPath, to: destinationIndexPath)
    }
    
    // MARK: Permissions
    
    /// Forward call to editingDelegate
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return editingDelegate?.tableView(tableView, canEditRowAt: indexPath) ?? false
    }
    
    /// Forward call to editingDelegate
    public func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool
    {
        return editingDelegate?.tableView(tableView, canMoveRowAt: indexPath) ?? false
    }


    // MARK: - UITableViewDelegate, UITableViewDataSource

    /// Register NIB for given row reusable identifier. 
    /// Make sure nib with certain reusable identifier is registered only once.
    public func register(row: SHMTableRowProtocol)
    {
        let rowNibString = row.reusableIdentifier
        
        if registeredNibs.contains(rowNibString)
        {
            return
        }
        
        if let _ = tableView?.dequeueReusableCell(withIdentifier: rowNibString)
        {
            registeredNibs.append(rowNibString)
            
            return
        }
        
        let bundle = row.bundle ?? defaultBundle
        let nib = UINib(nibName: rowNibString, bundle: bundle)
        tableView?.register(nib, forCellReuseIdentifier: rowNibString)
        
        registeredNibs.append(rowNibString)
    }
    
    /// Return header title for current section
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return sections[section].headerTitle
    }

    /// Return footer title for current section
    public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String?
    {
        return sections[section].footerTitle
    }

    /// Return header view for current section
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        return sections[section].headerView?.configure()
    }

    /// Return footer view for current section
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?
    {
        return sections[section].footerView?.configure()
    }

    /// Specify header height if possible
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return sections[section].headerView?.associatedView().frame.size.height ?? UITableViewAutomaticDimension
    }

    /// Specify footer height if possible
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        return sections[section].footerView?.associatedView().frame.size.height ?? UITableViewAutomaticDimension
    }
    
    /// Specify number of currently displayed sections
    public func numberOfSections(in tableView: UITableView) -> Int
    {
        return sections.count
    }
    
    /// Specify number of currently displayed rows under section
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        guard section < sections.count else { return 0 }
        
        return sections[section].rows.count
    }

    /// Will try to register row, dequeue cell, and return configured cell.
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        guard   indexPath.section < sections.count,
                indexPath.row < sections[indexPath.section].rows.count
                else
        {
            fatalError("Requesting cell on indexPath \(indexPath) out of bounds.")
        }
        
        let row = sections[indexPath.section].rows[indexPath.item]
        
        register(row: row)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: row.reusableIdentifier, for: indexPath as IndexPath)
        
        row.configure(tableViewCell: cell)
        
        return cell
    }
    
    /// Will try to find row, and call on it configureAtWillDisplay.
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        guard   indexPath.section < sections.count,
                indexPath.row < sections[indexPath.section].rows.count
                else
        {
            return
        }
        
        let row = sections[indexPath.section].rows[indexPath.item]
        
        row.configureAtWillDisplay(tableViewCell: cell)
    }

    /// Will try to find row, and call its primary action closure
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        guard   indexPath.section < sections.count,
                indexPath.row < sections[indexPath.section].rows.count
                else
        {
            return
        }
        
        let row = sections[indexPath.section].rows[indexPath.item]
        
        row.action?(indexPath)
    }

    // MARK: - Helpers

    internal func allCurrentlyVisibleSectionsAboutToBeDeleted(with sectionsToDelete: IndexSet) -> Bool
    {
        return sectionsToDelete.contains(integersIn: allCurrentlyVisibleSections())
    }
    
    internal func allCurrentlyVisibleSections() -> IndexSet
    {
        var visibleSections = IndexSet()
        tableView?.indexPathsForVisibleRows?.forEach { visibleSections.insert($0.section) }
        return visibleSections
    }
}
