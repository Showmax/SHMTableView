//
//  JFDiff.swift
//

import Foundation

// Based on code written by Jack Flintermann
// For original source code and separate pod library please visit: https://github.com/jflinter/Dwifft
//
// The MIT License (MIT)
//
// Copyright (c) 2015 Jack Flintermann
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//
// Solved via LCS (longest common subsequence) problem
//
// Created by Jack Flintermann on 3/14/15.
//
// The first thing is an algorithm that solves the Longest Common Subsequence problem.
// Pragmatically, the problem of finding the difference between two arrays is trivially reducable to the LCS problem,
// i.e. if you can find the longest common subsequence between two arrays, you've also found a series of transforms
// to apply to array 1 that will result in array 2. This algorithm is written purely in Swift, and uses dynamic programming
// to achieve substantial performance improvements over a naïve approach (that being said, there are several ways it could probably be 
// sped up.) If this kind of thing is interesting to you, there's a pretty great paper on diffing 
// algorithms: http://www.xmailserver.org/diff2.pdf
//

internal struct JFDiff<T>
{
    internal let results: [JFDiffStep<T>]
    
    internal var insertions: [JFDiffStep<T>]
    {
        return results.filter({ $0.isInsertion }).sorted { $0.idx < $1.idx }
    }
    
    internal var deletions: [JFDiffStep<T>]
    {
        return results.filter({ !$0.isInsertion }).sorted { $0.idx > $1.idx }
    }
    
    public func reversed() -> JFDiff<T> {
        let reversedResults = self.results.reversed().map { (result: JFDiffStep<T>) -> JFDiffStep<T> in
            switch result {
            case .insert(let i, let j):
                return .delete(i, j)
            case .delete(let i, let j):
                return .insert(i, j)
            }
        }
        return JFDiff<T>(results: reversedResults)
    }
}

internal func +<T> (left: JFDiff<T>, right: JFDiffStep<T>) -> JFDiff<T>
{
    return JFDiff<T>(results: left.results + [right])
}

///
/// These get returned from calls to Array.diff(). They represent insertions or deletions that need to happen to transform array 
/// a into array b.
///
internal enum JFDiffStep<T>: CustomDebugStringConvertible
{
    case insert(Int, T)
    case delete(Int, T)
    
    var isInsertion: Bool
    {
        switch self
        {
        case .insert:
            return true
        case .delete:
            return false
        }
    }
    
    var debugDescription: String
    {
        switch(self)
        {
        case .insert(let i, let j):
            return "+\(j)@\(i)"
        case .delete(let i, let j):
            return "-\(j)@\(i)"
        }
    }
    
    var idx: Int
    {
        switch self
        {
        case .insert(let i, _):
            return i
        case .delete(let i, _):
            return i
        }
    }
    
    var value: T
    {
        switch(self)
        {
        case .insert(let j):
            return j.1
        case .delete(let j):
            return j.1
        }
    }
}

internal struct JFLCSDiff
{
    static func diff(a: [SHMDiffable], b: [SHMDiffable]) -> JFDiff<SHMDiffable>
    {
        let table = buildTable(a, b, a.count, b.count)
        return backtrackDiffFromIndices(table, a, b, a.count, b.count)
    }
    
    /// Applies a generated diff to an array. The following should always be true:
    /// Given x: [T], y: [T], applyDiff(diff(x, y), to: x) == y
    static func applyDiff(_ diff: JFDiff<SHMDiffable>, to initialList: [SHMDiffable]) -> [SHMDiffable]
    {
        var result = initialList
        
        for deletion in diff.deletions
        {
            result.remove(at: deletion.idx)
        }
        
        for insertion in diff.insertions
        {
            result.insert(insertion.value, at: insertion.idx)
        }
        
        return result
    }
    
    private static func buildTable(_ x: [SHMDiffable], _ y: [SHMDiffable], _ n: Int, _ m: Int) -> [[Int]]
    {
        var table = Array(repeating: Array(repeating: 0, count: m + 1), count: n + 1)
        for i in 0...n
        {
            for j in 0...m
            {
                if i == 0 || j == 0
                {
                    table[i][j] = 0
                    
                } else if x[i-1].isEqual(to: y[j-1])
                {
                    table[i][j] = table[i-1][j-1] + 1
                    
                } else
                {
                    table[i][j] = max(table[i-1][j], table[i][j-1])
                }
            }
        }
        return table
    }
    
    /// Walks back through the generated table to generate the diff.
    private static func backtrackDiffFromIndices(
        _ table: [[Int]],
        _ x: [SHMDiffable],
        _ y: [SHMDiffable],
        _ i: Int,
        _ j: Int
        ) -> JFDiff<SHMDiffable>
    {
        if i == 0 && j == 0
        {
            return JFDiff<SHMDiffable>(results: [])
            
        } else if i == 0
        {
            return backtrackDiffFromIndices(table, x, y, i, j-1) + JFDiffStep.insert(j-1, y[j-1])
            
        } else if j == 0
        {
            return backtrackDiffFromIndices(table, x, y, i - 1, j) + JFDiffStep.delete(i-1, x[i-1])
            
        } else if table[i][j] == table[i][j-1]
        {
            return backtrackDiffFromIndices(table, x, y, i, j-1) + JFDiffStep.insert(j-1, y[j-1])
            
        } else if table[i][j] == table[i-1][j]
        {
            return backtrackDiffFromIndices(table, x, y, i - 1, j) + JFDiffStep.delete(i-1, x[i-1])
            
        } else
        {
            return backtrackDiffFromIndices(table, x, y, i-1, j-1)
        }
    }
}
