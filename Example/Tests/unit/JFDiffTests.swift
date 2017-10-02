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

import XCTest
import Nimble
@testable import SHMTableView

extension Character: SHMDiffable {
    public func isEqual(to other: SHMDiffable) -> Bool {
        guard let other = other as? Character else { return false }
        
        return self == other
    }
}

class JFDiffTests: XCTestCase {
    struct TestCase {
        let array1: [Character]
        let array2: [Character]
        let expectedLCS: [Character]
        let expectedDiff: String
        
        init(_ a: String, _ b: String, _ expected: String, _ expectedDiff: String) {
            self.array1 = Array(a.characters)
            self.array2 = Array(b.characters)
            self.expectedLCS = Array(expected.characters)
            self.expectedDiff = expectedDiff
        }
    }
    
    func testDiff() {
        let tests: [TestCase] = [
            TestCase("1234", "23", "23", "-1@0-4@3"),
            TestCase("0125890", "4598310", "590", "-0@0-1@1-2@2+4@0-8@4+8@3+3@4+1@5"),
            TestCase("BANANA", "KATANA", "AANA", "-B@0+K@0-N@2+T@2"),
            TestCase("1234", "1224533324", "1234", "+2@2+4@3+5@4+3@6+3@7+2@8"),
            TestCase("thisisatest", "testing123testing", "tsitest", "-h@1-i@2+e@1+t@3-s@5-a@6+n@5+g@6+1@7+2@8+3@9+i@14+n@15+g@16"),
            TestCase("HUMAN", "CHIMPANZEE", "HMAN", "+C@0-U@1+I@2+P@4+Z@7+E@8+E@9")
        ]
        
        for test in tests {
            let diff = JFLCSDiff.diff(a: test.array1, b: test.array2)
            let printableDiff = diff.results.map({ $0.debugDescription }).joined(separator: "")
            XCTAssertEqual(printableDiff, test.expectedDiff, "incorrect diff")
            
            let applied = JFLCSDiff.applyDiff(diff, to: test.array1) as? [Character]
            expect(applied).to(equal(test.array2))
            
            let reversed = diff.reversed()
            let reverseApplied = JFLCSDiff.applyDiff(reversed, to: test.array2) as? [Character]
            expect(reverseApplied).to(equal(test.array1))
        }
    }
}
