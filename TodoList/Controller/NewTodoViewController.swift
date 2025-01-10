import CoreData
import UIKit

class NewTodoViewController: UIViewController, UITextViewDelegate {
    @IBOutlet var textView: UITextView!
    @IBOutlet var datePicker: UIDatePicker!

    var item: TodoItem?

    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        datePicker.contentHorizontalAlignment = .leading
        sheetPresentationController?.prefersGrabberVisible = true
        sheetPresentationController?.detents = [.medium(), .large()]
        if let item {
            textView.text = item.title
            datePicker.date = item.time ?? Date()
        } else {
            DispatchQueue.main.async {
                self.textView.becomeFirstResponder()
            }
        }
    }

    @IBAction func saveTask() {
        guard let text = textView.text, !text.isEmpty else { return }
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
        textView.endEditing(true)
        dismiss(animated: true)
    }
}
