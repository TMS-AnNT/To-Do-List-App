//
//  EntryViewController.swift
//  TodoList
//
//  Created by Lê Anh Chiêu on 6/1/25.
//

import CoreData
import UIKit

class EntryViewController: UIViewController {
    @IBOutlet var textfield: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        textfield.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveTask))
    }
}

extension EntryViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        saveTask()
        return true
    }

    @objc func saveTask() {
        guard let text = textfield.text, !text.isEmpty else { return }
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let todoItem = TodoItem(context: context)
        todoItem.title = text
        todoItem.isComplete = false
        do {
            try context.save()
        } catch {
            print("Error creating todo: \(error)")
        }
        navigationController?.popViewController(animated: true)
    }
}
