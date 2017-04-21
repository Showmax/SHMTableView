//
//  SHMTableView+ UITableViewDataSource.swift
//  Pods
//
//  Created by Michal Fousek on 21/04/2017.
//
//

import Foundation

extension SHMTableView: UITableViewDataSource
{
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
}
