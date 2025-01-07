import CoreData
import Foundation

extension TodoItem {
    static func list(app: AppDelegate) -> [TodoItem] {
        let context = app.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<TodoItem> = TodoItem.fetchRequest()

        do {
            let items = try context.fetch(fetchRequest)
            return items
        } catch {
            print("Error fetching users: \(error)")
            return []
        }
    }

    static func save(app: AppDelegate, text: String) {
        let context = app.persistentContainer.viewContext
        let todoItem = TodoItem(context: context)
        todoItem.title = text
        todoItem.isComplete = false
        do {
            try context.save()
        } catch {
            print("Error creating todo: \(error)")
        }
    }

    func update(app: AppDelegate, text: String) {
        let context = app.persistentContainer.viewContext
        self.title = text
        try? context.save()
    }

    func update(app: AppDelegate, isComplete: Bool) {
        let context = app.persistentContainer.viewContext
        self.isComplete = isComplete
        try? context.save()
    }

    func toggleCheck(app: AppDelegate) {
        let context = app.persistentContainer.viewContext
        self.isComplete = !self.isComplete
        try? context.save()
    }

    func delete(app: AppDelegate) {
        let context = app.persistentContainer.viewContext
        context.delete(self)
        do {
            try context.save()
        } catch {
            print("Error deleting item: \(error)")
        }
    }
}
