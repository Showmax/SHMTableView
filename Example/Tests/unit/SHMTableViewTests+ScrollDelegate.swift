//
//  SHMTableViewTests+ScrollDelegate.swift
//  SHMTableView
//
//  Created by Michal Fousek on 21/04/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation

import XCTest
import SHMTableView
import Nimble


class SHMTableViewTestsScrollDelegate: LoggingTableTestCase, UIScrollViewDelegate {
    var scrollDelegateDidReceivedCall = false
    
    func test__whenSetScrollDelegate__scrollDelegateMethodCallsAreForwardedToScrollDelegate() {
        let rows = (0..<100).map({ SHMTableRow<LoggingTableViewCell>(model: "\($0)", reusableIdentifier: LoggingTableViewCell.reusableIdentifier) })
        
        let sections = [SHMTableSection(rows: rows)]
        viewController?.shmTable.update(withNewSections: sections, forceReloadData: true)
        
        viewController?.shmTable.scrollDelegate = self
        
        let contentSize = self.viewController?.tableView.contentSize ?? CGSize(width: 100.0, height: 2048.0)
        let scrollFrame = CGRect(x: 0.0, y: contentSize.height - 3.0, width: 1.0, height: 1.0)
        viewController?.tableView.scrollRectToVisible(scrollFrame, animated: false)
        
        expect(self.scrollDelegateDidReceivedCall) == true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollDelegateDidReceivedCall = true
    }
}
