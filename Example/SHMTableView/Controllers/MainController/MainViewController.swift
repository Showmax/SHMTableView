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

import UIKit
import SHMTableView

/**
 
 This is the main controller of the app. It builds a list of examples.
 
 There is no surprise it uses our generic table SHMTableView as well.
 
 Please start with SimpleRowViewController and go through all other controllers in order to study the main one.
 
 All you've learned into this point is here as well plus one more thing - custom header view for a section.

 */

class MainViewController: SHMTableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // instantiate default section
        let section = SHMTableSection()
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        // our section is not title/string based, so we need to set the view and model to it
        // so instead of section.headerTitle you need to use section.headerView and assign to it a generic SHMTableHeader.
        if let view = createLogoHeaderView() {
            // this header is also controled by a model
            // the approach is exaclty the same as for rows
            section.headerView = SHMTableHeader<MainControllerHeaderCell>(model: nil, view: view)
        }

        #if os(tvOS)
            section += createUpdatingSimpleRow()
        #else
            section += createSimpleRowsRow()
            section += createTableInTableRow()
            section += createInteractionsRow()
            section += createCarouselRow()
            section += createUpdatingSimpleRow()
            section += createUpdatingViewModelRow()
            section += createEditingRow()
            section += createComparisonUITableViewRow()
            section += createComparisonSHMTableViewRow()
            section += createTextFieldKeyboardRow()
            section += createPeekAndPopRow()
        #endif

        shmTable += section
    }

    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)

        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    // MARK: - Create rows

    func createSimpleRowsRow() -> SHMTableRow<MainControllerCell> {
        return SHMTableRow<MainControllerCell>(
            model: MainControllerModel(
                title: "Simple rows",
                desc: "This example demonstrates some basics. It uses just one type of cell, no sections at all."
            ),
            action: { [weak self] indexPath in

                guard let me = self else { return }

                #if os(tvOS)
                    me.showUnsupportedTVOSExampleAlert()
                #else
                    me.performSegue(withIdentifier: "SimpleRowSegue", sender: self)
                #endif

                me.tableView.deselectRow(at: indexPath, animated: true)
            }
        )
    }

    func createTableInTableRow() -> SHMTableRow<MainControllerCell>
    {
        return SHMTableRow<MainControllerCell>(
            model: MainControllerModel(
                title: "Table in Table",
                desc: "This example demonstrates how to SHMTableView in a row of another SHMTableView."
            ),
            action: { [weak self] indexPath in

                guard let me = self else { return }
                #if os(tvOS)
                    me.showUnsupportedTVOSExampleAlert()
                #else
                    me.performSegue(withIdentifier: "TableInTableSegue", sender: self)
                #endif

                me.tableView.deselectRow(at: indexPath, animated: true)
            }
        )
    }

    func createInteractionsRow() -> SHMTableRow<MainControllerCell>
    {
        return SHMTableRow<MainControllerCell>(
            model: MainControllerModel(
                title: "Interactions",
                desc: "This example demonstrates how to connect things together and get an action."
            ),
            action: { [weak self] indexPath in

                guard let me = self else { return }

                #if os(tvOS)
                    me.showUnsupportedTVOSExampleAlert()
                #else
                    me.performSegue(withIdentifier: "InteractionSegue", sender: self)
                #endif

                me.tableView.deselectRow(at: indexPath, animated: true)
            }
        )

    }

    func createCarouselRow() -> SHMTableRow<MainControllerCell>
    {
        return SHMTableRow<MainControllerCell>(
            model: MainControllerModel(title: "Carousel", desc: "This example is desmonstration complex use of SHMTableViews."),
            action: { [weak self] indexPath in

                guard let me = self else { return }

                #if os(tvOS)
                    me.showUnsupportedTVOSExampleAlert()
                #else
                    me.performSegue(withIdentifier: "CarouselSegue", sender: self)
                #endif

                me.tableView.deselectRow(at: indexPath, animated: true)
            }
        )
    }

    func createUpdatingSimpleRow() -> SHMTableRow<MainControllerCell>
    {
        return SHMTableRow<MainControllerCell>(
            model: MainControllerModel(title: "Updating (simple)", desc: "Switch between two lists and watch how table rows gets updated."),
            action: { [weak self] indexPath in

                guard let me = self else { return }

                me.performSegue(withIdentifier: "UpdatingSimpleSegue", sender: self)

                me.tableView.deselectRow(at: indexPath, animated: true)
            }
        )
    }

    func createUpdatingViewModelRow() -> SHMTableRow<MainControllerCell> {
        return SHMTableRow<MainControllerCell>(
            model: MainControllerModel(
                title: "Updating (using view model)",
                desc: "Switch between two lists and shuffle rows. Demonstration of view model usage."
            ),
            action: { [weak self] indexPath in

                guard let me = self else { return }

                #if os(tvOS)
                    me.showUnsupportedTVOSExampleAlert()
                #else
                    me.performSegue(withIdentifier: "UpdatingViewModelSegue", sender: self)
                #endif

                me.tableView.deselectRow(at: indexPath, animated: true)
            }
        )
    }

    func createEditingRow() -> SHMTableRow<MainControllerCell>
    {
        return SHMTableRow<MainControllerCell>(
            model: MainControllerModel(title: "Editing", desc: "Demonstration of table in editing mode."),
            action: { [weak self] indexPath in

                guard let me = self else { return }

                #if os(tvOS)
                    me.showUnsupportedTVOSExampleAlert()
                #else
                    me.performSegue(withIdentifier: "EditingSegue", sender: self)
                #endif

                me.tableView.deselectRow(at: indexPath, animated: true)
            }
        )
    }

    func createComparisonUITableViewRow() -> SHMTableRow<MainControllerCell>
    {
        return SHMTableRow<MainControllerCell>(
            model: MainControllerModel(title: "Comparison - using UITableView", desc: "Simple list using classic UITableView."),
            action: { [weak self] indexPath in

                guard let me = self else { return }

                #if os(tvOS)
                    me.showUnsupportedTVOSExampleAlert()
                #else
                    me.performSegue(withIdentifier: "ComparisonUITableViewSegue", sender: self)
                #endif

                me.tableView.deselectRow(at: indexPath, animated: true)
            }
        )
    }

    func createComparisonSHMTableViewRow() -> SHMTableRow<MainControllerCell>
    {
        return SHMTableRow<MainControllerCell>(
            model: MainControllerModel(title: "Comparison - using SHMTableView", desc: "Simple list using SHMTableView."),
            action: { [weak self] indexPath in

                guard let me = self else { return }

                #if os(tvOS)
                    me.showUnsupportedTVOSExampleAlert()
                #else
                    me.performSegue(withIdentifier: "ComparisonSHMTableViewSegue", sender: self)
                #endif

                me.tableView.deselectRow(at: indexPath, animated: true)
            }
        )
    }

    func createTextFieldKeyboardRow() -> SHMTableRow<MainControllerCell>
    {
        return SHMTableRow<MainControllerCell>(
            model: MainControllerModel(
                title: "UITextField + Keyboard",
                desc: "Demonstrating that keyboard is not hiding table view content."
            ),
            action: { [weak self] indexPath in

                guard let me = self else { return }

                #if os(tvOS)
                    me.showUnsupportedTVOSExampleAlert()
                #else
                    me.performSegue(withIdentifier: "UITextFieldTestSegue", sender: self)
                #endif

                me.tableView.deselectRow(at: indexPath, animated: true)
            }
        )
    }

    func createPeekAndPopRow() -> SHMTableRow<MainControllerCell>
    {
        return SHMTableRow<MainControllerCell>(
            model: MainControllerModel(
                title: "Peek and pop preview",
                desc: "Preview Peek & Pop with Fibonacci numbers"
            ),
            action: { [weak self] indexPath in

                guard let me = self else { return }

                #if os(tvOS)
                    me.showUnsupportedTVOSExampleAlert()
                #else
                    me.performSegue(withIdentifier: "NumbersSegue", sender: self)
                #endif

                me.tableView.deselectRow(at: indexPath, animated: true)
            }
        )
    }

    // MARK: - Helpers

    func createLogoHeaderView() -> UIView?
    {
        #if os(tvOS)
            return Bundle.main.loadNibNamed("ShowMaxHeader+tvOS", owner: nil, options: nil)?[0] as? UIView
        #else
            return Bundle.main.loadNibNamed("ShowMaxHeader", owner: nil, options: nil)?[0] as? UIView
        #endif
    }

    func showUnsupportedTVOSExampleAlert()
    {
        let alert = UIAlertController(title: "Example not ported for tvOS. Please see iOS example.", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in }))
        present(alert, animated: true, completion: nil)
    }
}
