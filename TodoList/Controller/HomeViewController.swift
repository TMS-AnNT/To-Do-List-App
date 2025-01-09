import CoreData
import UIKit

class HomeViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var segmented: UISegmentedControl!
    private var fetchedResultsController: NSFetchedResultsController<TodoItem>!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Todo list"
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        setupTableView()
        setupFetchedResultsController()
        try? fetchedResultsController.performFetch()
    }

    @IBAction func onTypeChange(_ sender: UISegmentedControl) {
        let fetchRequest = TodoItem.fetchRequest()

        switch sender.selectedSegmentIndex {
        case 0:
            fetchRequest.predicate = nil
        case 1:
            fetchRequest.predicate = NSPredicate(format: "isCompleted == %@", NSNumber(value: true))
        case 2:
            fetchRequest.predicate = NSPredicate(format: "isCompleted == %@", NSNumber(value: false))
        default:
            break
        }

        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "time", ascending: true)]

        fetchedResultsController.fetchRequest.predicate = fetchRequest.predicate
        try? fetchedResultsController.performFetch()

        UIView.animate(withDuration: 0.25) {
            self.tableView.reloadData()
        }
    }

    @IBAction func didAddTap() {
        let vc = storyboard?.instantiateViewController(identifier: "entry") as! NewTodoViewController
        present(vc, animated: true)
    }

    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(
            UINib(nibName: TaskTableViewCell.identifier, bundle: nil),
            forCellReuseIdentifier: TaskTableViewCell.identifier
        )
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
    }

    func setupFetchedResultsController() {
        let fetchRequest = TodoItem.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "time", ascending: false)]

        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: coreDataContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        fetchedResultsController.delegate = self
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = fetchedResultsController.object(at: indexPath)
        item.isCompleted.toggle()
        app.saveContext()
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = fetchedResultsController.object(at: indexPath)
            coreDataContext.delete(item)
            app.saveContext()
        }
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections?[section]
        return sectionInfo?.numberOfObjects ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: TaskTableViewCell.identifier,
            for: indexPath
        ) as! TaskTableViewCell

        let item = fetchedResultsController.object(at: indexPath)
        cell.setData(item)
        cell.editButton.tag = indexPath.row
        cell.editButton.addTarget(self, action: #selector(openEditing(_:)), for: .touchUpInside)

        return cell
    }

    @objc func openEditing(_ sender: UIButton) {
        // Lấy item từ fetchedResultsController
        let row = sender.tag
        let item = fetchedResultsController.object(at: IndexPath(row: row, section: 0))

        // Mở màn hình chỉnh sửa
        let vc = storyboard?.instantiateViewController(identifier: "entry") as! NewTodoViewController
        vc.item = item
//        navigationController?.pushViewController(vc, animated: true)
        present(vc, animated: true)
    }
}

extension HomeViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?)
    {
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }

        case .delete:
            if let indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }

        case .update:
            if let indexPath {
                let cell = tableView.cellForRow(at: indexPath) as? TaskTableViewCell
                let item = controller.object(at: indexPath) as! TodoItem
                cell?.setData(item)
            }

        case .move:
            if let indexPath, let newIndexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }

        @unknown default:
            break
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
