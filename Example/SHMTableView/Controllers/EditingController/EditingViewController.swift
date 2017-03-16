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
import SHMTableView

/**
 
 This controller demonstrates how to handle editing mode when UITableView is managed by SHMTableView.
 
 Example will present list of favourite movies. Movies can be removed from list by swiping over from right to left.
 Movies can be added using "plus sign" button. Button "edit" in navigationbar will turn on editing mode, 
 that will enable to batch remove multiple items.
 
 Controller must implement SHMTableViewEditingDelegate to be able to respond to editing events.
 
 */
class EditingViewController: SHMTableViewController
{
    @IBOutlet weak var addBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var editBarButtonItem: UIBarButtonItem!
    
    /// List of favourite movie names
    fileprivate var favouriteMoviesModel: [String] = []
    
    ///
    /// Setup editingDelegate to self. Setup initial list of favourite movies.
    ///
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        shmTable.editingDelegate = self
        
        favouriteMoviesModel = [
            "Big Bang Theory",
            "Friends",
            "Alladin",
            "Shaun The Sheep",
            "Little Fockers"
        ]
        
        updateTableWithCurrentModel()
    }
}

// MARK: - Actions

extension EditingViewController
{
    /// 
    /// Tapping the add button will present alert with input field to write name of new favourite movie.
    /// New favourite submitted movie is appended to favouriteMoviesMode and table is reloaded
    ///
    @IBAction func addTapped(_ sender: Any? = nil)
    {
        // open prompt, ask for movie title, and save
        let alert = UIAlertController(title: "What is your favourite movie?", message: "Enter a text", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.text = ""
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            if  let textFields = alert?.textFields,
                !textFields.isEmpty,
                let text = textFields[0].text
            {
                self.favouriteMoviesModel.append(text)
                self.updateTableWithCurrentModel()
            }
        }))
        present(alert, animated: true, completion: nil)
    }
    
    ///
    /// Tapping the edit button will switch UITableView to editing mode.
    ///
    @IBAction func editTapped(_ sender: Any)
    {
        let editing = !self.isEditing
        
        self.setEditing(editing, animated: true)
        
        shmTable.setEditing(editing, animated: true)
        
        if editing
        {
            addBarButtonItem.isEnabled = false
            editBarButtonItem.title = "Done"
            
        } else
        {
            addBarButtonItem.isEnabled = true
            editBarButtonItem.title = "Edit"
        }
    }
}

// MARK: - SHMTableViewEditingDelegate

extension EditingViewController: SHMTableViewEditingDelegate
{
    ///
    /// Determine what editing style button to show on row. 
    /// For last row we show insert button, for other we show delete button.
    ///
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle
    {
        guard indexPath.row < favouriteMoviesModel.count else { return  .none }
        
        if indexPath.row == favouriteMoviesModel.count - 1
        {
            return .insert
            
        } else
        {
            return .delete
        }
    }
    
    /// 
    /// After editing style button was tapped we handle appropriate action.
    /// For insert we show alert with input field. For Delete we remove movie from model and update table.
    ///
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        guard indexPath.row < favouriteMoviesModel.count else { return }
        
        if editingStyle == .insert
        {
            addTapped()
            
        } else if editingStyle == .delete
        {
            favouriteMoviesModel.remove(at: indexPath.row)
            updateTableWithCurrentModel()
        }
    }
    
    /// 
    /// When moving row we need to update our model as well.
    ///
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
    {
        guard   sourceIndexPath.row < favouriteMoviesModel.count,
                destinationIndexPath.row < favouriteMoviesModel.count else { return }

        let element = favouriteMoviesModel[sourceIndexPath.row]
        favouriteMoviesModel.remove(at: sourceIndexPath.row)
        favouriteMoviesModel.insert(element, at: destinationIndexPath.row)
    }
    
    /// For purpose of this example we allow editing on every row
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    /// For purpose of this example we allow moving on every row
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
}

// MARK: - Helpers

fileprivate extension EditingViewController
{
    ///
    /// Map favourite names to view cell types and update the table.
    ///
    func updateTableWithCurrentModel()
    {
        let section = SHMTableSection()
        
        section.rows = favouriteMoviesModel.map{ SHMTableRow<SimpleXibTableViewCell>(model: $0) }
        
        shmTable.update(withNewSections: [section])
    }
}
