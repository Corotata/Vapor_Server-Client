//
//  ViewController.swift
//  Todo
//
//  Created by Corotata on 2018/7/6.
//  Copyright © 2018 Corotata. All rights reserved.
//

import UIKit
import Moya

class ViewController: UIViewController {
    var todos: [Todo] = []
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadRequest()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CreateTodoSegue" {
            let viewController = segue.destination as? CreateTodoViewController
            viewController?.delegate = self
        }
    }
    
    
    func loadRequest() {
        _ = ApiProvider.requestArrayModel(TodoAPI.queryTodos, model: Todo.self) {[weak self] (response) in
            guard let todos = response?.data else {
                return
            }
            self?.todos = todos
            self?.tableView.reloadData()
        }
    }
}



extension ViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoTableViewCell", for: indexPath) as! TodoTableViewCell
        cell.todo = todos[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        var todo = self.todos[indexPath.row]
        
        let actionTitle: String
        if todo.isFinish {
            actionTitle = "Change it Unfinish"
        }else {
            actionTitle = "Change it Finish"
        }
        
        let changeStateAction: UIContextualAction = UIContextualAction(style: .destructive, title: actionTitle) { (_, _, result) in
            _ = ApiProvider.requestModel(TodoAPI.updateTodoState(id: todo.id!, isFinish: !todo.isFinish), model: Todo.self, completion: { [weak self](response) in
                if response?.code == HTTPCode.success.rawValue {
                    todo.isFinish = !todo.isFinish
                    self?.todos[indexPath.row] = todo
                    self?.tableView.reloadRows(at: [indexPath], with: .none)
                    result(false)
                }
            })
        }
        changeStateAction.backgroundColor = UIColor.orange
        
        let deleteRowAction = UIContextualAction(style: .destructive, title: "Delete") { (_, _, result) in
            _ = ApiProvider.requestModel(TodoAPI.deleteTodo(id: todo.id!), model: Todo.self) {[weak self] (response) in
                if response?.code == HTTPCode.success.rawValue {
                    self?.todos.remove(at: indexPath.row)
                    self?.tableView.deleteRows(at: [indexPath], with: .fade)
                    result(true)
                }
            }
        }
        
        let config = UISwipeActionsConfiguration(actions: [deleteRowAction,changeStateAction])
        return config
    }
    
}


extension ViewController: CreateTodoViewControllerDelegate {
    func createTodoViewControllerDidSaveSuccess(todo: Todo) {
        todos.insert(todo, at: 0)
        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
    }
}

