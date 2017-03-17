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
 
 Defines list of categories with subordinate videos. Also is able to return list of categories with shuffled videos.
 
 */
class VideoListModel
{
    /// Represents the video title and whether is suitable for kids.
    struct Video
    {
        var isForKids: Bool
        var title: String
    }
    
    /// Represents category title and subordinate videos.
    struct Category
    {
        var title: String
        var videos: [Video]
    }
    
    /// List of categories with videos in initial order
    var categories: [Category]
    
    /// List of categories with randmly shuffled videos. Ordering should be different with each call.
    var categoriesWithShuffledVideos: [Category]
    {
        return categories.map { category -> Category in
            var category = category
            category.videos = self.shuffleArray(category.videos)
            return category
        }
    }
    
    /// Creates initial structure of categories and videos
    init()
    {
        categories = [
            
            Category(
                title: "Adventures",
                videos: [
                    Video(isForKids: false, title: "Atlantis"),
                    Video(isForKids: true, title: "Bedtime Stories"),
                    Video(isForKids: true, title: "Disney Favourites"),
                    Video(isForKids: false, title: "Game Of Thrones"),
                    Video(isForKids: false, title: "Mission: Impossible"),
                    Video(isForKids: true, title: "Piggy Tales"),
                    Video(isForKids: false, title: "Stargate"),
                    Video(isForKids: false, title: "Transformers")
                ]
            ),
            
            Category(
                title: "Comedy",
                videos: [
                    Video(isForKids: true, title: "101 Dalmations"),
                    Video(isForKids: true, title: "Alladin"),
                    Video(isForKids: false, title: "Big Bang Theory"),
                    Video(isForKids: false, title: "Friends"),
                    Video(isForKids: false, title: "Little Fockers"),
                    Video(isForKids: true, title: "Shaun The Sheep"),
                    Video(isForKids: true, title: "Smurfs"),
                    Video(isForKids: false, title: "Sex And The City"),
                    Video(isForKids: false, title: "Silicon Valley")
                ]
            ),
            
            
            Category(
                title: "Documentary",
                videos: [
                    Video(isForKids: true, title: "Blue Planet"),
                    Video(isForKids: false, title: "David Attenborough's Natural Curiosities"),
                    Video(isForKids: false, title: "Lions On The Move"),
                    Video(isForKids: false, title: "Mandela"),
                    Video(isForKids: false, title: "One Life"),
                    Video(isForKids: false, title: "Shoreline")
                ]
            )
            
        ]
    }
    
    // MARK: - Helpers
    
    // Source: Fisher–Yates shuffle on http://iosdevelopertips.com/swift-code/swift-shuffle-array-type.html
    private func shuffleArray<T>(_ inArray: [T]) -> [T]
    {
        guard inArray.count > 1 else { return inArray }
        
        var array = inArray
        
        for index in ((0 + 1)...array.count - 1).reversed()
        {
            // Random int from 0 to index-1
            let j = Int(arc4random_uniform(UInt32(index - 1)))
            
            // Swap two array elements
            // Notice '&' required as swap uses 'inout' parameters
            swap(&array[index], &array[j])
        }
        
        return array
    }
}
