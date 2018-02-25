//
//  TodoListTableVC.swift
//  TodoListClient
//
//  Created by Oren Idan on 09/07/2017.
//  Copyright © 2017 Oren Idan. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa
import Result

class TodoListTableVC: UITableViewController, TodoCellDelegate {
    
    //@@ofirbt - use DI
    let todoListViewModel = TodoListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        todoListViewModel.todoViewModels.signal.observe(on: UIScheduler()).observeValues { (values) in
            self.tableView.reloadData()
        }
        todoListViewModel.getAllTodos()
    }
    
    func actionTapped(todoVM: TodoItemViewModel?) {
        if let todoVM = todoVM {
            todoVM.completed.value = !todoVM.completed.value
            self.todoListViewModel.editTodo(id: todoVM.id, todoVM: todoVM)
        }
    }
    
    @IBAction func add(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter Task"
        }
        let saveAction = UIAlertAction(title: "Add", style: .default) { (alertAction) in
            let textField = alertController.textFields![0]
            self.todoListViewModel.createTodo(title: textField.text!)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {_ in})
        
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.todoListViewModel.todoViewModels.value.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! TodoCell
        let todo = todoListViewModel.todoViewModels.value[indexPath.row]
        cell.updateCell(todoVM: todo, delegate: self)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.todoListViewModel.deleteTodo(id: indexPath.row)
        }
    }
}


