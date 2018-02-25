//
//  TodoStore.swift
//  TodoListClient
//
//  Created by Ofir Ben-Tzur on 25/02/2018.
//  Copyright © 2018 Oren Idan. All rights reserved.
//

import Foundation
import ReactiveSwift

protocol TodoStore  {
    func getAll() -> SignalProducer<[Todo], StoreError>
    func create(title: String) -> SignalProducer<Todo, StoreError>
    func edit(todo: Todo) -> SignalProducer<Todo, StoreError>
    func delete(id: Int) -> SignalProducer<Void, StoreError>
}
