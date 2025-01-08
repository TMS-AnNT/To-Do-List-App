import UIKit

class TaskTableViewCell: UITableViewCell {
    static let identifier = "TaskTableViewCell"
    @IBOutlet var label: UILabel!
    @IBOutlet var date: UILabel!
    @IBOutlet var radioButton: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setData(_ task: TodoItem) {
        label.text = task.title
        radioButton.image = UIImage(systemName: task.isCompleted ? "record.circle" : "circle")
        radioButton.tintColor = task.isCompleted ? .tintColor : .systemGray
        date.text = task.time?.formatted(date: .long, time: .complete)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
