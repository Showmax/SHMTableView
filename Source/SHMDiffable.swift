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

import Foundation

/**
 
 Protocol is used in JFDiff.swift when searching for changes between two lists.
 By default is implemented by SHMTableSection, SHMTableRow and String.
 
 You can optionally implement it in your own models to make diffing more faster and more accurate. 
 
 */
public protocol SHMDiffable
{
    func isEqual(to other: SHMDiffable) -> Bool
}

extension String: SHMDiffable
{
    public func isEqual(to other: SHMDiffable) -> Bool
    {
        guard let other = other as? String else { return false }
        
        return self == other
    }
} 
