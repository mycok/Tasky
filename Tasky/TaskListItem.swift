//
//  ChecklistItem.swift
//  Tasky
//
//  Created by Myko.k on 28/04/2021.
//

import Foundation

class TaskListItem: NSObject, Codable {
    var text = ""
    var checked = false
    
    func toggleChecked() {
        checked.toggle()
    }
}
