//
//  TodoStoreImpl.swift
//  TodoListClient
//
//  Created by Ofir Ben-Tzur on 25/02/2018.
//  Copyright © 2018 Oren Idan. All rights reserved.
//

import Foundation
import ReactiveSwift

class TodoStoreImpl: TodoStore  {
    
    let todoNetworkService: TodoNetworkService
    
    //@@ofirbt - use DI lib
    internal init(todoNetworkService: TodoNetworkService = TodoNetworkServiceImpl()) {
        
        self.todoNetworkService = todoNetworkService
    }
    
    public func getAll() -> SignalProducer<[Todo], StoreError> {
        
        return self.todoNetworkService.getAll().mapError({ (error) -> StoreError in
            //@@ofirbt - handle properly
            return StoreError.dataFetchingError
        })
    }
    
    func create(title: String) -> SignalProducer<Todo, StoreError> {
        return self.todoNetworkService.create(title: title).mapError({ (error) -> StoreError in
            //@@ofirbt - handle properly
            return StoreError.dataFetchingError
        })
    }
    
    func edit(todo: Todo) -> SignalProducer<Todo, StoreError> {
        return self.todoNetworkService.edit(todo: todo).mapError({ (error) -> StoreError in
            //@@ofirbt - handle properly
            return StoreError.dataFetchingError
        })
    }
    
    func delete(id: Int) -> SignalProducer<Void, StoreError> {
        return self.todoNetworkService.delete(id: id).mapError({ (error) -> StoreError in
            //@@ofirbt - handle properly
            return StoreError.dataFetchingError
        })
    }
}
