//
//  ListItem.swift
//  GroceyList
//
//  Created by Ramachandra petla on 10/24/22.
//

import UIKit
import Foundation

class ListItem: NSObject {
    var name: String
    var category: String
    var checked: Bool
    
    init(name: String, category: String, checked: Bool) {
        self.name = name
        self.category = category
        self.checked = checked
    }
}
