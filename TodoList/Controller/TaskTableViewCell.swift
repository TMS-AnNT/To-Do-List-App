import UIKit

class TaskTableViewCell: UITableViewCell {
    static let identifier = "TaskTableViewCell"
    @IBOutlet var label: UILabel!
    @IBOutlet var checkbox: UISwitch!

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
        checkbox.isOn = task.isComplete
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
