//
//  ChecklistItem.swift
//  Tasky
//
//  Created by Myko.k on 28/04/2021.
//

import Foundation

class ChecklistItem {
    var text = ""
    var checked = false
    
    func toggleChecked() {
        checked.toggle()
    }
}
