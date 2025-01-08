import CoreData
import UIKit

class EntryViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var textfield: UITextField!
    @IBOutlet var datePicker: UIDatePicker!

    override func viewDidLoad() {
        super.viewDidLoad()
        textfield.delegate = self
        sheetPresentationController?.prefersGrabberVisible = true
        sheetPresentationController?.detents = [.medium(), .large()]
        textfield.becomeFirstResponder()
    }

    @IBAction func saveTask() {
        guard let text = textfield.text, !text.isEmpty else { return }
        let todoItem = TodoItem(context: coreDataContext)
        todoItem.title = text
        todoItem.isCompleted = false
        todoItem.time = datePicker.date
        do {
            try coreDataContext.save()
            dismiss(animated: true)
        } catch {
            print("Error creating todo: \(error)")
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        saveTask()
        return true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
