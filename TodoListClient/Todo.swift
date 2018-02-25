//
//  Todo.swift
//  TodoListClient
//
//  Created by Oren Idan on 09/07/2017.
//  Copyright © 2017 Oren Idan. All rights reserved.
//

import Foundation

class Todo {
    let id: Int
    var title: String
    var completed: Bool
    
    init(id: Int, title: String, completed: Bool = false) {
        self.id = id
        self.title = title
        self.completed = completed
    }
}
