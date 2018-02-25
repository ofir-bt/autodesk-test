//
//  TodoMapper.swift
//  TodoListClient
//
//  Created by Ofir Ben-Tzur on 25/02/2018.
//  Copyright © 2018 Oren Idan. All rights reserved.
//

import Foundation


protocol TodoMapper {
    func TodoToTodoViewModel(todo: Todo?) -> TodoItemViewModel?
    func TodoViewModelToTodo(todoVM: TodoItemViewModel?) -> Todo?
}

class TodoMapperImpl: TodoMapper    {
    
    func TodoToTodoViewModel(todo: Todo?) -> TodoItemViewModel?   {
        if let todo = todo  {
            return TodoItemViewModel(id: todo.id, title: todo.title, completed: todo.completed)
        }
        return nil
    }
    
    func TodoViewModelToTodo(todoVM: TodoItemViewModel?) -> Todo?   {
        if let todoVM = todoVM  {
            return Todo(id: todoVM.id, title: todoVM.title.value, completed: todoVM.completed.value)
        }
        return nil
    }
}
