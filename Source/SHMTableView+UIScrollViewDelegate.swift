//
//  SHMTableView+UIScrollViewDelegate.swift
//  Pods
//
//  Created by Michal Fousek on 21/04/2017.
//
//

import Foundation

/// This extension only forward all method calls for `UIScrollViewDelegate` protocol which come from table view.
/// 
/// I really don't know why method calls from `scrollDelegate` are handled as closures by swift.
extension SHMTableView: UIScrollViewDelegate
{
    public func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        scrollDelegate?.scrollViewDidScroll?(scrollView)
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView)
    {
        scrollDelegate?.scrollViewWillBeginDragging?(scrollView)
    }
    
    public func scrollViewWillEndDragging(
        _ scrollView: UIScrollView,
        withVelocity velocity: CGPoint,
        targetContentOffset: UnsafeMutablePointer<CGPoint>
        )
    {
        scrollDelegate?.scrollViewWillEndDragging?(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
    {
        scrollDelegate?.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
    }
    
    public func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool
    {
        return scrollDelegate?.scrollViewShouldScrollToTop?(scrollView) ?? true
    }
    
    public func scrollViewDidScrollToTop(_ scrollView: UIScrollView)
    {
        scrollDelegate?.scrollViewDidScrollToTop?(scrollView)
    }
    
    public func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView)
    {
        scrollDelegate?.scrollViewWillBeginDecelerating?(scrollView)
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        scrollDelegate?.scrollViewDidEndDecelerating?(scrollView)
    }
    
    public func viewForZooming(in scrollView: UIScrollView) -> UIView?
    {
        return scrollDelegate?.viewForZooming?(in: scrollView)
    }
    
    public func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?)
    {
        scrollDelegate?.scrollViewWillBeginZooming?(scrollView, with: view)
    }
    
    public func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat)
    {
        scrollDelegate?.scrollViewDidEndZooming?(scrollView, with: view, atScale: scale)
    }
    
    public func scrollViewDidZoom(_ scrollView: UIScrollView)
    {
        scrollDelegate?.scrollViewDidZoom?(scrollView)
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView)
    {
        scrollDelegate?.scrollViewDidEndScrollingAnimation?(scrollView)
    }
}
