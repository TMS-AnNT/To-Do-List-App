//
//  TaskViewController.swift
//  TodoList
//
//  Created by Lê Anh Chiêu on 6/1/25.
//

import UIKit

class TaskViewController: UIViewController {
    @IBOutlet var taskLabel: UILabel!

    var item: TodoItem?
    var currentPosition: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        taskLabel.text = item?.title
    }
}
