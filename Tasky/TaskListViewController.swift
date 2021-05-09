//
//  ViewController.swift
//  Tasky
//
//  Created by Myko.k on 19/04/2021.
//

import UIKit

class TaskListViewController: UITableViewController, AddTaskListItemViewControllerDelegate {
    var items:[TaskListItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true

        loadTaskLists()
    }
    
//    MARK:- Helper methods
    func addNewTaskItem(item: TaskListItem) {
            let newRowIndex = items.count
            
            items.append(item)
            
            let indexPath = IndexPath(row: newRowIndex, section: 0)
            let indexPaths = [indexPath]
            
            tableView.insertRows(at: indexPaths, with: .automatic)
        }
    
    func configureCheckmark(for cell: UITableViewCell, with item: TaskListItem) {
        let label = cell.viewWithTag(1001) as! UILabel
        if item.checked {
            label.text = "✔︎"
        } else {
            label.text = ""
        }
    }
    
    func configureText(for cell: UITableViewCell, with item: TaskListItem) {
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
    }
    
// MARK:- Table View Data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskListItem", for: indexPath)
        let item = items[indexPath.row]
        
        configureText(for: cell, with: item)
        configureCheckmark(for: cell, with: item)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        items.remove(at: indexPath.row)
        saveTaskLists()
        
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
//    MARK:- Table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = items[indexPath.row]
            item.toggleChecked()
            configureCheckmark(for: cell, with: item)
            
            saveTaskLists()
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
//    MARK:- AddItemViewControllerDelegate
    func AddTaskListItemViewControllerDidCancel(_ controller: AddTaskListItemViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func AddTaskListItemViewController(_ controller: AddTaskListItemViewController, didFinishAdding item: TaskListItem) {
        addNewTaskItem(item: item)
        saveTaskLists()
        
        navigationController?.popViewController(animated: true)
    }
    
    func AddTaskListItemViewController(_controller: AddTaskListItemViewController, didFinishEditing item: TaskListItem) {
        if let index = items.firstIndex(of: item) {
            items[index] = item
            saveTaskLists()
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(for: cell, with: item)
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
//    MARK:- Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! AddTaskListItemViewController
        
        if segue.identifier == "AddTasklistItem" {
            controller.delegate = self
        } else {
            controller.delegate = self
            
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                let item = items[indexPath.row]
                controller.itemToEdit = item
            }
        }
    }
    
//    MARK:- Data persistance
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        return paths[0]
    }
    
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Taskslist.plist")
    }
    
    func saveTaskLists() {
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(items)
            try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
        } catch {
            print("Error decoding items array \(error.localizedDescription)")
        }
    }
    
    func loadTaskLists() {
        let path = dataFilePath()
        
        if let data = try? Data(contentsOf: path) {
            let decoder = PropertyListDecoder()
            
            do {
                items = try decoder.decode([TaskListItem].self, from: data)
            } catch {
                print("Error decoding tasklist array: \(error.localizedDescription)")
            }
        }
    }
    

}

