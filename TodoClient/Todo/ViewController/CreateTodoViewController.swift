//
//  CreateTodoViewController.swift
//  Todo
//
//  Created by Corotata on 2018/7/9.
//  Copyright © 2018 Corotata. All rights reserved.
//

import UIKit

protocol CreateTodoViewControllerDelegate: NSObjectProtocol {
    func createTodoViewControllerDidSaveSuccess(todo: Todo)
}

class CreateTodoViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var saveBarButtonItem: UIBarButtonItem!
    weak var delegate: CreateTodoViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveTodoClick(_ sender: UIBarButtonItem) {
        guard  let title = textView.text else {
            return
        }
        _  = ApiProvider.requestModel(TodoAPI.createTodo(title: title), model: Todo.self, completion: { (response) in
            guard let todo = response?.data else {
                return
            }
            self.delegate?.createTodoViewControllerDidSaveSuccess(todo: todo)
            self.navigationController?.popViewController(animated: true)
        })
    }
    
}

extension CreateTodoViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        self.saveBarButtonItem.isEnabled = textView.text.count > 0
    }
}
