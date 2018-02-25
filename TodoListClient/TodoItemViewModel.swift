//
//  TodoItemViewModel.swift
//  TodoListClient
//
//  Created by Ofir Ben-Tzur on 25/02/2018.
//  Copyright © 2018 Oren Idan. All rights reserved.
//

import Foundation
import ReactiveCocoa
import ReactiveSwift

class TodoItemViewModel: NSObject {
    
    let id: Int
    var title: MutableProperty<String> = MutableProperty("")

    var completed: MutableProperty<Bool> = MutableProperty(false)
    
    init(id: Int, title: String, completed: Bool = false) {
        self.id = id
        self.title.value = title
        self.completed.value = completed
    }
    
}
