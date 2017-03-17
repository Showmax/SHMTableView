# SHMTableView

[![Swift][swift-badge]][swift-url]
[![Platform][platform-badge]][platform-url]
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

**SHMTableView** is a wrapper around `UITableView` datasource, that helps you define table contents by mapping view types to model instances.

`SHMTableView` helps you abstract away the routine stuff in `UITableViewDataSource` and `UITableViewDelegate`. Instead you can focus on structure and content to be displayed by `UITableView`.

To use `SHMTableView`, you must:

1. Create data model instances
2. Map data models to view types
3. Pass your mapping to the `SHMTableView` library

`SHMTableView` creates and configures all `UITableViewCell` instances to be displayed in `UITableView`.

## Installation

`SHMTableView` is available through [CocoaPods](http://cocoapods.org).

Add the following line to your `Podfile`

```ruby
pod 'SHMTableView'
```

Install dependencies

```bash
pod install
```

## Getting Started

1) Include `SHMTableView` into your swift file

```swift
import SHMTableView
```

2) Tell `SHMTableView` to manage `UITableView` datasource and delegate

```swift
var table = SHMTableView(tableView: tableView)
```

3) Define your table sections and rows

```swift
var section = SHMTableSection()
section += SHMTableRow<MovieCell>(model: Movie(name: "Monsters, Inc."))
section += SHMTableRow<MovieCell>(model: Movie(name: "Singin' in the Rain"))
section += SHMTableRow<SeriesCell>(model: Series(name: "Shaun the Sheep", numberOfEpisodes: 40))
section += SHMTableRow<MovieCell>(model: Movie(name: "My Fair Lady, Inc."))
section += SHMTableRow<SeriesCell>(model: Series(name: "Friends", numberOfEpisodes: 236))
```

4) Pass the content structure to the `SHMTableView`

```swift
table.update(withNewSections: [section])
```

Result: your content displays in `UITableView`

## Documentation

### Rows

Each cell requires one model that describes the content and behavior of the cell. The model can be any protocol, struct, class or even just plain String.

```swift
struct Movie
{
    let name: String
    let director: String
    let watch: ((Void) -> Void)
}
```

Each cell must conform to the `SHMConfigurableRow` protocol. Specify each model type via typealias.

```swift
class MovieCell: UITableViewCell, SHMConfigurableRow
{
    typealias T = Movie

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var directorLabel: UILabel!

    func configure(_ model: T)
    {
        // called during tableView(_:cellForRowAt:)
    }

    func configureAtWillDisplay(_ model: T)
    {
        // called during tableView(_:willDisplay:forRowAt:)
        nameLabel.text = model.name
        directorLabel.text = model.director
    }
}
```

Connect the view type with the model instance

```swift
let monsters = Movie(
    name: "Monsters, Inc.",
    director: "Pete Docter, Lee Unkrich, David Silverman",
    watch: { /* start video player */ }
)

var row = SHMTableRow<MovieCell>(model: monsters)
row.action = { indexPath in

    // called on tableView(_:didSelectRowAt:)
    monsters.watch()
}
```

`SHMTableView` loads NIB with the same name as the cell type. The library and `UITableView` use this name as reuse identifier when registering cells to `UITableView`.

### Sections

To divide rows you can add sections.

```swift
let sectionWithMusicals = SHMTableSection(rows: [
    SHMTableRow<SimpleCell>(model: Movie(name: "Singin' in the Rain")),
    SHMTableRow<SimpleCell>(model: Movie(name: "My Fair Lady")),
    SHMTableRow<SimpleCell>(model: Movie(name: "The Sound of Music"))
])

let sectionForKids = SHMTableSection(rows: [
    SHMTableRow<ColorfulCell>(model: Movie(name: "Shaun the Sheep")),
    SHMTableRow<ColorfulCell>(model: Movie(name: "Monsters, Inc.")),
    SHMTableRow<ColorfulCell>(model: Movie(name: "Shrek"))
])

moviesTable += sectionWithMusicals
moviesTable += sectionForKids
```

### Headers and Footers

Headers and footers can contain titles or views.

Titles can be specified for sections:

```swift
let musicals = SHMTableSection()
musicals.headerTitle = "Musicals (header)"
musicals.footerTitle = "Musicals (footer)"
```

Alternatively a view, can be used instead of title:

```swift
let musicals = SHMTableSection()

if let view = Bundle.main.loadNibNamed("ColorfulHeaderView", owner: nil, options: nil)?[0] as? UIView
{
    musicals.headerView = SHMTableHeader<ColorfulHeaderView>(model: "Musicals (header)", view: view)
}

if let view = Bundle.main.loadNibNamed("ColorfulFooterView", owner: nil, options: nil)?[0] as? UIView
{
    musicals.footerView = SHMTableHeader<ColorfulFooterView>(model: "Musicals (footer)", view: view)
}
```

Custom header/footer view must conform to `SHMConfigurable` protocol.

```swift
class ColorfulHeaderView: UIView, SHMConfigurable
{
    typealias T = String

    @IBOutlet var label: UILabel!

    func configure(_ model: T)
    {
        label.text = model
    }
}
```

### Updating table content

Table sections and rows can be updated via `update(withNewSections:)` method.

For example, the table is first filled with some initial content.

```swift
let table = SHMTableView(tableView: tableView)

table.update(withNewSections: [
    SHMTableSection(rows: [
        SHMTableRow<TitleCell>(model: "Atlantis"),
        SHMTableRow<TitleCell>(model: "Mission: Impossible"),
        SHMTableRow<TitleCell>(model: "Stargate"),
    ]),
    SHMTableSection(rows: [
        SHMTableRow<TitleCell>(model: "Big Bang Theory"),
        SHMTableRow<TitleCell>(model: "Friends"),
        SHMTableRow<TitleCell>(model: "Shaun The Sheep"),
    ])
])
```

Some time later the table can be updated with changed sections and rows:

```swift
table.update(withNewSections: [
    SHMTableSection(rows: [
        SHMTableRow<TitleCell>(model: "Atlantis"),
        SHMTableRow<TitleCell>(model: "Mission: Impossible"),
        SHMTableRow<TitleCell>(model: "Game Of Thrones"),  // new
        SHMTableRow<TitleCell>(model: "Stargate"),
        SHMTableRow<TitleCell>(model: "Transformers"),     // new
    ]),
    SHMTableSection(rows: [
        SHMTableRow<TitleCell>(model: "Friends"),
        SHMTableRow<TitleCell>(model: "Shaun The Sheep"),
    ]),
    SHMTableSection(rows: [
        SHMTableRow<TitleCell>(model:"Blue Planet"),       // new
        SHMTableRow<TitleCell>(model:"Lions On The Move"), // new
        SHMTableRow<TitleCell>(model:"Shoreline"),         // new
    ])
])
```

Method  `update(withNewSections:)`  internally computes diff between current list and new list. Once it knows changes, the method tries to animate the section and row changes if it is possible. Our example above causes these updates:

- insertions
    - two rows in first section
        - Game of Thrones
        - Transformers
    - whole new third section
- deletions
    - one rows in second section
        - Big Bang Theory

Optionally, you can improve diffing by implementing `SHMDiffable` into your model.

```swift
extension Movie: SHMDiffable
{
    public func isEqual(to other: SHMDiffable) -> Bool
    {
        guard let other = other as? Movie else { return false }

        return self.name == other.name
    }
}
```

### Operators

Append section to table

```swift
table += SHMTableSection()
```

Append row to the first section in table. Creates section, if table is empty.

```swift
table += SHMTableRow<MovieCell>(model: Movie(name: "Singin' in the Rain"))
```

Append row to specific section.

```swift
section += SHMTableRow<MovieCell>(model: Movie(name: "Singin' in the Rain"))
```

Append array of rows to specific section.

```swift
section += [
    SHMTableRow<ColorfulCell>(model: Movie(name: "Shaun the Sheep")),
    SHMTableRow<ColorfulCell>(model: Movie(name: "Monsters, Inc.")),
    SHMTableRow<ColorfulCell>(model: Movie(name: "Shrek"))
]
```

### Using UITableView in editing mode

See example in `Example/SHMTableView/EditingController`

### Using in view controller

You can map `SHMTableView` instance to `UITableView` in outlet variable `didSet` handler. Alternatively you can use `SHMTableViewController`, which does exactly that.

```swift
import SHMTableView

class MyViewController: UIViewController
{
    public var shmTable: SHMTableView!

    @IBOutlet weak var tableView: UITableView!
    {
        didSet
        {
            shmTable = SHMTableView(tableView: tableView)
        }
    }
}
```

## Example code

To run the example project, clone the repo, and run `pod install` from the Example directory.

```
cd libs/SHMTableView/Example
pod install
open SHMTableView.xcworkspace
```

## Comparison of SHMTableView and plain UITableView

#### Example of using SHMTableView

```swift
var table = SHMTableView(tableView: tableView)

table += [
    SHMTableSection(rows: [
        SHMTableRow<MusicalCell>(model: Movie(name: "Singin' in the Rain")),
        SHMTableRow<MusicalCell>(model: Series(name: "Nashville")),
        SHMTableRow<MusicalCell>(model: Movie(name: "My Fair Lady")),
        SHMTableRow<MusicalCell>(model: Series(name: "Glee"))
    ]),
    SHMTableSection(rows: [
        SHMTableRow<KidsCell>(model: Movie(name: "Monsters, Inc.")),
        SHMTableRow<KidsCell>(model: Series(name: "Shaun the Sheep")),
        SHMTableRow<KidsCell>(model: Movie(name: "Shrek"))
    ])    
]
```

Instances of models are mapped to the view types and passed to the `SHMTableView` library, which creates required sections and rows in `UITableView`.

#### Example of using plain UITableView

```swift
// Registering cells to UITableView

// ...

// Implementing UITableViewDataSource

public func numberOfSections(in tableView: UITableView) -> Int
{
    // ...
}

public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
{
    // ...
}

public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
{
    let model = ...

    if  let movieModel = model as? Movie,
        let cell = tableView.dequeueReusableCell(withReuseIdentifier: "Movie", for: indexPath) as? MovieCell
    {
        cell.nameLabel.text = item.title
        return cell

    } else if  let seriesModel = model as? Series,
        let cell = tableView.dequeueReusableCell(withReuseIdentifier: "Series", for: indexPath) as? MovieCell
    {
        cell.nameLabel.text = item.title
        return cell

    } else
    {
        fail()
    }
}

public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
{
    let model = ...

    if model is Movie
    {
        // ...

    } else if model is Series
    {
        // ...
    }
}

// Implementing UITableViewDelegate

public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
{
    let model = ...

    if model is Movie
    {
        // ...

    } else if model is Series
    {
        // ...
    }
}

// Setup section headers and footers

// ...

// Setup cell self sizing

// ...
```

Using plain `UITableView` requires you to implement all the data sources and delegate methods. You have to handle updates in a model structure. You have to write a lot of repetitive code. Each additional view and model requires more if-else checking, ending up with complex and difficult to maintain code.

## Development

```
cd libs/SHMTableView/Example
pod install
open SHMTableView.xcworkspace
```

## Future Ideas

- animate row reloads and moves (currently are supported insertions and deletions)
- support table header view


## Thanks

- [Dwifft](https://github.com/jflinter/Dwifft) by Jack Flintermann is very nice implementation of diff algorithm based on solving Longest Common Subsequence problem. Available as separate Pod library. We have customized original code to our needs.

## Authors

Showmax is an internet-based subscription video on demand service supplying an extensive catalogue of TV shows and movies. By leveraging relationships with major production studios from across the globe, Showmax delivers both world-class international content as well as the best of specialised local content. Showmax is accessible across a wide range of devices from smart TVs and computers to smartphones and tablets.

You can follow us at https://tech.showmax.com and/or https://twitter.com/ShowmaxDevs .

## Status

This code is exactly one running in our production app. We are using the same pod as you see here. PRs are welcome.

## License

`SHMTableView` is available under the Apache license. See the `LICENSE` file for more info.

[swift-badge]: https://img.shields.io/badge/Swift-3.0-orange.svg?style=flat
[swift-url]: https://swift.org
[platform-badge]: https://img.shields.io/badge/Platforms-iOS%20+%20tvOS-lightgray.svg?style=flat
[platform-url]: https://swift.org
[mit-badge]: https://img.shields.io/badge/License-MIT-blue.svg?style=flat
[mit-url]: https://tldrlegal.com/license/mit-license
[travis-badge]: https://travis-ci.org/showmax/shmtableview.svg?branch=master
[travis-url]: https://travis-ci.org/showmax/shmtableview
