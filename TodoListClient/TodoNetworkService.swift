//
//  TodoNetworkService.swift
//  TodoListClient
//
//  Created by Ofir Ben-Tzur on 25/02/2018.
//  Copyright © 2018 Oren Idan. All rights reserved.
//

import Foundation
import ReactiveSwift


protocol TodoNetworkService  {
    func getAll() -> SignalProducer<[Todo], NetworkError>
    func create(title: String) -> SignalProducer<Todo, NetworkError>
    func edit(todo: Todo) -> SignalProducer<Todo, NetworkError>
    func delete(id: Int) -> SignalProducer<Void, NetworkError>
}
