//
//  AddItemTableViewController.swift
//  Tasky
//
//  Created by Myko.k on 01/05/2021.
//

import UIKit

protocol AddItemViewControllerDelegate: class {
    func addItemViewControllerDidCancel(_ controller: AddItemTableViewController)
    
    func addItemViewController(_ controller: AddItemTableViewController, didFinishAdding item: ChecklistItem)
}

class AddItemTableViewController: UITableViewController, UITextFieldDelegate {
    weak var delegate: AddItemViewControllerDelegate?

    @IBOutlet weak var addItemTextfield: UITextField!
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        let newItem = ChecklistItem()
        newItem.text = addItemTextfield.text!
        
        delegate?.addItemViewController(self, didFinishAdding: newItem)
    }
    
    @IBAction func cancel() {
        delegate?.addItemViewControllerDidCancel(self)
    }
}
