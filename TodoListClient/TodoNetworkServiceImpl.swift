//
//  Networking.swift
//  TodoListClient
//
//  Created by Ofir Ben-Tzur on 25/02/2018.
//  Copyright © 2018 Oren Idan. All rights reserved.
//

import Foundation
import ReactiveSwift
import SwiftyJSON
import Alamofire

class TodoNetworkServiceImpl: TodoNetworkService  {
    
    private let queue = DispatchQueue(label: "TodoListClient.queue1")
    
    func getAll() -> SignalProducer<[Todo], NetworkError> {
        
        return SignalProducer { observer, disposable in
            let serializer = Alamofire.DataRequest.jsonResponseSerializer()
            Alamofire.request("http://ec2-52-32-105-2.us-west-2.compute.amazonaws.com:8080/all")
                .response(queue: self.queue, responseSerializer: serializer) {
                    response in
                    switch response.result {
                    case .success(let data):
                        // @@ofirbt - use a mapper
                        // @@ofirbt - handle parsing errors
                        var todos = [Todo]()
                        let json = JSON(data)
                        json.forEach({ (key, jsonElement) in
                            
                            if let title = jsonElement["title"].string,
                                let id = jsonElement["id"].int,
                                let completed = jsonElement["completed"].bool   {
                                todos.append(Todo(id: id, title: title, completed: completed))
                            }
                        })
                        observer.send(value: todos)
                        observer.sendCompleted()
                    case .failure( _):
                        
                        // @@ofirbt - todo
                        observer.send(error: NetworkError.connectionError)
                    }
            }
        }
    }
    
    func create(title: String) -> SignalProducer<Todo, NetworkError> {
        let parameters: Parameters = ["title": title]
        
        return SignalProducer { observer, disposable in
            let serializer = Alamofire.DataRequest.jsonResponseSerializer()
            
            Alamofire.request("http://ec2-52-32-105-2.us-west-2.compute.amazonaws.com:8080/new", method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .response(queue: self.queue, responseSerializer: serializer) {
                    response in
                    switch response.result {
                    case .success(let data):
                        // @@ofirbt - use a mapper
                        // @@ofirbt - handle parsing errors
                        let json = JSON(data)
                        
                        if let title = json["title"].string,
                            let id = json["id"].int,
                            let completed = json["completed"].bool   {
                            let created = Todo(id: id, title: title, completed: completed)
                            observer.send(value: created)
                            observer.sendCompleted()
                        }
                        else    {
                            observer.send(error: NetworkError.parsingError)
                        }
                        
                        
                        
                    case .failure( _):
                        
                        // @@ofirbt - todo
                        observer.send(error: NetworkError.connectionError)
                    }
            }
        }
    }
    
    func edit(todo: Todo) -> SignalProducer<Todo, NetworkError> {
        
        let parameters: Parameters = ["completed": todo.completed]
        
        return SignalProducer { observer, disposable in
            let serializer = Alamofire.DataRequest.jsonResponseSerializer()
            
            Alamofire.request("http://ec2-52-32-105-2.us-west-2.compute.amazonaws.com:8080/update/\(todo.id)", method: .put, parameters: parameters, encoding: JSONEncoding.default)
                .response(queue: self.queue, responseSerializer: serializer) {
                    response in
                    switch response.result {
                    case .success(let data):
                        // @@ofirbt - use a mapper
                        // @@ofirbt - handle parsing errors
                        let json = JSON(data)
                        
                        if let title = json["title"].string,
                            let id = json["id"].int,
                            let completed = json["completed"].bool   {
                            let updated = Todo(id: id, title: title, completed: completed)
                            observer.send(value: updated)
                            observer.sendCompleted()
                        }
                        else    {
                            observer.send(error: NetworkError.parsingError)
                        }
                    case .failure( _):
                        
                        // @@ofirbt - todo
                        observer.send(error: NetworkError.connectionError)
                    }
            }
        }
    }
    
    func delete(id: Int) -> SignalProducer<Void, NetworkError> {
        
        return SignalProducer { observer, disposable in
            let serializer = Alamofire.DataRequest.jsonResponseSerializer()
            
            Alamofire.request("http://ec2-52-32-105-2.us-west-2.compute.amazonaws.com:8080/delete/\(id)", method: .delete, encoding: JSONEncoding.default)
                .response(queue: self.queue, responseSerializer: serializer) {
                    response in
                    switch response.result {
                    case .success( _):
                        // @@ofirbt - use a mapper
                        // @@ofirbt - handle parsing errors
                        observer.sendCompleted()
                    case .failure( _):
                        
                        // @@ofirbt - todo
                        observer.send(error: NetworkError.connectionError)
                    }
            }
        }
    }
    
    
}



