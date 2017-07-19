//
//  SHMTableView+UITableViewDelegate.swift
//  Pods
//
//  Created by Michal Fousek on 21/04/2017.
//
//

import Foundation
import UIKit

extension SHMTableView: UITableViewDelegate
{
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
    
    /// Will try to find row, and call on it configureOnHide.
    public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        guard   indexPath.section < sections.count,
                indexPath.row < sections[indexPath.section].rows.count
                else
        {
            return
        }
        
        let row = sections[indexPath.section].rows[indexPath.item]
        
        row.configureOnHide(tableViewCell: cell)
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
}
