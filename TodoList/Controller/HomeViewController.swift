import CoreData
import UIKit

class HomeViewController: UIViewController {
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var segmented: UISegmentedControl!
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
            self.collectionView.reloadData()
        }
    }

    @IBAction func didAddTap() {
        present(newTodoViewController, animated: true)
    }

    private var expandedItems: Set<NSManagedObjectID> = []

    private var fetchedResultsController: NSFetchedResultsController<TodoItem>!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Todo list"
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        setupCollectionView()
        setupFetchedResultsController()
        try? fetchedResultsController.performFetch()
    }

    func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerTodoCollectionViewCell()
        let layout = TodoCollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.itemSize.width = collectionView.frame.width
        collectionView.collectionViewLayout = layout
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

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        toggleExpanded(for: indexPath)
        collectionView.reloadItems(at: [indexPath])
        collectionView.deselectItem(at: indexPath, animated: true)
    }

    func isExpanded(for item: TodoItem) -> Bool {
        return expandedItems.contains(item.objectID)
    }

    func toggleExpanded(for item: TodoItem) {
        if expandedItems.contains(item.objectID) {
            expandedItems.remove(item.objectID)
        } else {
            expandedItems.insert(item.objectID)
        }
    }

    func toggleExpanded(for indexPath: IndexPath) {
        let item = fetchedResultsController.object(at: indexPath)
        if expandedItems.contains(item.objectID) {
            expandedItems.remove(item.objectID)
        } else {
            expandedItems.insert(item.objectID)
        }
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections?[section]
        return sectionInfo?.numberOfObjects ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueTodoCollectionViewCell(indexPath: indexPath)
        let item = fetchedResultsController.object(at: indexPath)
        cell.setData(data: item)
        cell.onCheckPress = {
            item.isCompleted.toggle()
            self.app.saveContext()
        }
        cell.onDeletePress = {
            let aleart = UIAlertController(
                title: "Confirm",
                message: "You sure you want to delete?",
                preferredStyle: .alert
            )

            let deleteAction = UIAlertAction(
                title: "Delete",
                style: .destructive,
                handler: { _ in
                    self.coreDataContext.delete(item)
                    self.app.saveContext()
                }
            )

            let cancelAction = UIAlertAction(
                title: "Cancel",
                style: .cancel,
                handler: nil
            )

            aleart.addAction(deleteAction)
            aleart.addAction(cancelAction)

            self.present(aleart, animated: true)
        }
        cell.onEditPress = {
            let vc = self.newTodoViewController
            vc.item = item
            self.present(vc, animated: true)
        }
        cell.isExpanded = isExpanded(for: item)
        return cell
    }
}

extension HomeViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?)
    {
        collectionView.performBatchUpdates {
            switch type {
            case .insert:
                if let newIndexPath = newIndexPath {
                    collectionView.insertItems(at: [newIndexPath])
                }

            case .delete:
                if let indexPath = indexPath {
                    collectionView.deleteItems(at: [indexPath])
                }

            case .update:
                if let indexPath = indexPath {
                    collectionView.reloadItems(at: [indexPath])
                }

            case .move:
                if let indexPath = indexPath, let newIndexPath = newIndexPath {
                    collectionView.moveItem(at: indexPath, to: newIndexPath)
                }

            @unknown default:
                break
            }
        }
    }
}
