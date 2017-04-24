//
//  XCTextCase+Waiting.swift
//  SHMTableView
//
//  Created by Michal Fousek on 24/04/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation

import XCTest

extension XCTestCase
{
    /// This method can be used to wait for asynchronous operation in tests.
    ///
    /// - Parameters:
    ///   - timeout: Time which has asynchronous operation to finish it's work. When `done` closure is not called until this time pass then assert
    ///              is fired.
    ///   - file: #file
    ///   - function: #function
    ///   - action: Closure in which will be asynchronous operation executed.
    ///             `done` parameter is closure which must be called when asynchronous operation finishes.
    func shmwait(
        timeout: TimeInterval = 1.0,
        file: String = #file,
        function: String = #function,
        action: @escaping (_ done: @escaping () -> Void) -> Void
        )
    {
        let filename = file.components(separatedBy: "/").last ?? ""
        let expect = expectation(description: "\(filename): \(function)")
        
        action({
            
            expect.fulfill()
        })
        
        waitForExpectations(timeout: timeout)
    }
}
