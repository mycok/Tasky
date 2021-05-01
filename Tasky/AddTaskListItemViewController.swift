//
//  AddItemTableViewController.swift
//  Tasky
//
//  Created by Myko.k on 01/05/2021.
//

import UIKit

protocol AddTaskListItemViewControllerDelegate: class {
    func AddTaskListItemViewControllerDidCancel(_ controller: AddTaskListItemViewController)
    
    func AddTaskListItemViewController(_ controller: AddTaskListItemViewController, didFinishAdding item: TaskListItem)
    
    func AddTaskListItemViewController(_controller: AddTaskListItemViewController, didFinishEditing item: TaskListItem)
}

class AddTaskListItemViewController: UITableViewController, UITextFieldDelegate {
    weak var delegate: TaskListViewController?
    
    var itemToEdit: TaskListItem?

    @IBOutlet weak var addItemTextfield: UITextField!
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let itemToEdit = itemToEdit {
            title = "Edit Task List"
            addItemTextfield.text = itemToEdit.text
            doneButton.isEnabled = true
        }
        
        navigationItem.largeTitleDisplayMode = .never

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addItemTextfield.becomeFirstResponder()
    }
    
//    MARK:- Tableview Delegate
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
//    MARK:- Textfield Delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let oldText = textField.text!
        let stringRange = Range(range, in: oldText)!
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        
        doneButton.isEnabled = !newText.isEmpty
        
       return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        doneButton.isEnabled = false
        
        return true
    }

//    MARK:- Actions
    @IBAction func done() {
        if let itemToEdit = itemToEdit {
            itemToEdit.text = addItemTextfield.text!
            delegate?.AddTaskListItemViewController(_controller: self, didFinishEditing: itemToEdit)
            
        } else {
            let newItem = TaskListItem()
            newItem.text = addItemTextfield.text!
            
            delegate?.AddTaskListItemViewController(self, didFinishAdding: newItem)
        }
       
    }
    
    @IBAction func cancel() {
        delegate?.AddTaskListItemViewControllerDidCancel(self)
        
    }
}
