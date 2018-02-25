//
//  TodoViewModel.swift
//  TodoListClient
//
//  Created by Ofir Ben-Tzur on 25/02/2018.
//  Copyright © 2018 Oren Idan. All rights reserved.
//

import Foundation
import ReactiveSwift
import ReactiveCocoa

class TodoListViewModel: NSObject {
    
    private let todoStore: TodoStore
    private let todoMapper: TodoMapper
    
    let todoViewModels: MutableProperty<[TodoItemViewModel]> = MutableProperty([])
    
    //@@ofirbt - use DI lib
    internal init(todoStore: TodoStore = TodoStoreImpl(), todoMapper: TodoMapper = TodoMapperImpl()) {
        
        self.todoStore = todoStore
        self.todoMapper = todoMapper
        super.init()
    }
    
    func getAllTodos()  {
        let signalProducer = todoStore.getAll();
        
        signalProducer.startWithSignal {(observer, disposable) -> () in
            observer.observeResult({ result in
                
                // @@ofirbt - map somehow
                var todoVMs = [TodoItemViewModel]()
                if let todos = result.value    {
                    for todo in todos {
                        if let todoVM = self.todoMapper.TodoToTodoViewModel(todo: todo)  {
                            todoVMs.append(todoVM)
                        }
                    }
                }
                self.todoViewModels.swap(todoVMs)
            })
        }
    }
    
    func editTodo(id: Int, todoVM: TodoItemViewModel)  {
        
        
        if let todo = todoMapper.TodoViewModelToTodo(todoVM: todoVM)    {
            let signalProducer = todoStore.edit(todo: todo)
            
            signalProducer.startWithSignal {(observer, disposable) -> () in
                observer.observeResult({ result in
                    
                    
                    if let updatedTodoVM = self.todoMapper.TodoToTodoViewModel(todo: result.value)  {
                        
                        // Could be more efficient
                        for i in 0..<self.todoViewModels.value.count{
                            if self.todoViewModels.value[i].id == id {
                                self.todoViewModels.value[i] = updatedTodoVM
                            }
                        }
                    }
                    
                })
            }
        }
    }
    
    func createTodo(title: String)  {
        let signalProducer = todoStore.create(title: title)
        
        signalProducer.startWithSignal {(observer, disposable) -> () in
            observer.observeResult({ result in
                
                if let createdTodoVM = self.todoMapper.TodoToTodoViewModel(todo: result.value)  {
                    self.todoViewModels.value.append(createdTodoVM)
                }
            })
        }
    }
    
    func deleteTodo(id: Int)    {
        let signalProducer = todoStore.delete(id: id)
        
        signalProducer.startWithSignal {(observer, disposable) -> () in
            observer.observeResult({ (result) in
                self.todoViewModels.value.remove(at: id)
            })
        }
    }
}



