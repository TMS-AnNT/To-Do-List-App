import UIKit

class TaskTableViewCell: UICollectionViewCell {
    static let identifier = "TaskTableViewCell"
    @IBOutlet var label: UILabel!
    @IBOutlet var date: UILabel!
    @IBOutlet var radioButton: UIImageView!
    @IBOutlet var editButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setData(_ task: TodoItem) {
        label.text = task.title
        radioButton.image = UIImage(systemName: task.isCompleted ? "checkmark.square" : "square")
        radioButton.tintColor = task.isCompleted ? .tintColor : .systemGray
        date.text = task.time?.formatted(date: .long, time: .shortened)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
