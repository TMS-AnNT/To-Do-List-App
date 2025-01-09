import CoreData
import UIKit

class NewTodoViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var textfield: UITextField!
    @IBOutlet var datePicker: UIDatePicker!

    var item: TodoItem?

    override func viewDidLoad() {
        super.viewDidLoad()
        textfield.delegate = self
        datePicker.contentHorizontalAlignment = .leading
        sheetPresentationController?.prefersGrabberVisible = true
        sheetPresentationController?.detents = [.medium(), .large()]
        if let item {
            textfield.text = item.title
            datePicker.date = item.time ?? Date()
        }
        DispatchQueue.main.async {
            self.textfield.becomeFirstResponder()
        }
    }

    @IBAction func saveTask() {
        guard let text = textfield.text, !text.isEmpty else { return }
        if let item {
            item.title = text
            item.isCompleted = false
            item.time = datePicker.date
        } else {
            let todoItem = TodoItem(context: coreDataContext)
            todoItem.title = text
            todoItem.isCompleted = false
            todoItem.time = datePicker.date
        }
        app.saveContext()
        textfield.endEditing(true)
        dismiss(animated: true)
    }
}
