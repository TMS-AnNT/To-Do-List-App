import CoreData
import Foundation
import UIKit

extension UIViewController {
    var app: AppDelegate {
        UIApplication.shared.delegate as! AppDelegate
    }

    var coreDataContext: NSManagedObjectContext {
        app.persistentContainer.viewContext
    }
}
