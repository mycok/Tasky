//
//  ViewController.swift
//  Tasky
//
//  Created by Myko.k on 19/04/2021.
//

import UIKit

class TaskListViewController: UITableViewController, AddTaskListItemViewControllerDelegate {
    var items = [TaskListItem]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationController?.navigationBar.prefersLargeTitles = true

            let item1 = TaskListItem()
            item1.text = "Walk the dog"
            items.append(item1)
            
            let item2 = TaskListItem()
            item2.text = "Brush my teeth"
            item2.checked = true
            items.append(item2)
            
            let item3 = TaskListItem()
            item3.text = "Learn iOS development"
            item3.checked = true
            items.append(item3)
            
            let item4 = TaskListItem()
            item4.text = "Soccer practice"
            items.append(item4)
            
            let item5 = TaskListItem()
            item5.text = "Eat ice cream"
            items.append(item5)
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
        
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
//    MARK:- Table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = items[indexPath.row]
            item.toggleChecked()
            configureCheckmark(for: cell, with: item)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
//    MARK:- AddItemViewControllerDelegate
    func AddTaskListItemViewControllerDidCancel(_ controller: AddTaskListItemViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func AddTaskListItemViewController(_ controller: AddTaskListItemViewController, didFinishAdding item: TaskListItem) {
        addNewTaskItem(item: item)
        
        navigationController?.popViewController(animated: true)
    }
    
    func AddTaskListItemViewController(_controller: AddTaskListItemViewController, didFinishEditing item: TaskListItem) {
        if let index = items.firstIndex(of: item) {
//            items[index] = item
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


}

