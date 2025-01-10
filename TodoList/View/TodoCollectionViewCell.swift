//
//  TaskCollectionViewCell.swift
//  TodoList
//
//  Created by Lê Anh Chiêu on 9/1/25.
//

import Foundation
import UIKit

class TodoCollectionViewCell: UICollectionViewCell {
    static let identifier = "TaskCollectionViewCell"

    private lazy var containerStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        return stack
    }()

    private lazy var vstack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .leading
        return stack
    }()

    private lazy var hstack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 8
        return stack
    }()

    private lazy var actionStack: UIStackView = {
        let stack = UIStackView()
        let spacer = UIView()
        spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
        stack.axis = .horizontal
        stack.spacing = 8
        stack.isHidden = true
        stack.addArrangedSubview(spacer)
        return stack
    }()

    private lazy var checkbox: UIButton = {
        let button: UIButton = .init()
        button.configuration = .plain()
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(checkboxTappped), for: .touchUpInside)
        return button
    }()

    private lazy var taskLabel: UILabel = {
        let label: UILabel = .init()
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var statusLabel: UILabel = {
        let label: UILabel = .init()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.alpha = 0.5
        label.font = label.font.withSize(12)
        return label
    }()

    private lazy var editButton: UIButton = {
        let button: UIButton = .init()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = .plain()
        button.configuration?.image = UIImage(systemName: "pencil")
        button.tintColor = .tintColor
        button.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return button
    }()

    private lazy var deleteButton: UIButton = {
        let button: UIButton = .init()
        button.imageView?.tintColor = .systemRed
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = .plain()
        button.tintColor = .red
        button.configuration?.image = UIImage(systemName: "trash")
        button.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        return button
    }()

    var onCheckPress: (() -> Void)?
    var onDeletePress: (() -> Void)?
    var onEditPress: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        settupView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func checkboxTappped() {
        onCheckPress?()
    }

    @objc func deleteButtonTapped() {
        onDeletePress?()
    }

    @objc func editButtonTapped() {
        onEditPress?()
    }

    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let targetSize = CGSize(width: layoutAttributes.frame.width, height: 0)
        layoutAttributes.frame.size = contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        return layoutAttributes
    }

    var isExpanded: Bool = false {
        didSet {
            if isExpanded {
                taskLabel.numberOfLines = 0
                actionStack.isHidden = false
            } else {
                taskLabel.numberOfLines = 3
                actionStack.isHidden = true
            }
        }
    }

    func setData(data: TodoItem) {
        taskLabel.text = data.title
        checkbox.configuration?.image = UIImage(systemName: data.isCompleted ? "checkmark.square" : "square")
        checkbox.tintColor = data.isCompleted ? .tintColor : .systemGray
        statusLabel.text = data.relativeTimeToNow
    }

    func settupView() {
        actionStack.addArrangedSubview(editButton)
        actionStack.addArrangedSubview(deleteButton)
        vstack.addArrangedSubview(taskLabel)
        vstack.addArrangedSubview(statusLabel)
        hstack.addArrangedSubview(checkbox)
        hstack.addArrangedSubview(vstack)

        containerStack.addArrangedSubview(hstack)
        containerStack.addArrangedSubview(actionStack)

        contentView.backgroundColor = .systemGray6
        contentView.layer.cornerRadius = 8
        contentView.addSubview(containerStack)

        NSLayoutConstraint.activate([
            containerStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            containerStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            containerStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
}

extension TodoItem {
    var relativeTimeToNow: String? {
        let formatter = RelativeDateTimeFormatter()
        if let time {
            return formatter.localizedString(for: time, relativeTo: Date.now)
        }
        return nil
    }
}

extension UICollectionView {
    func registerTodoCollectionViewCell() {
        register(
            TodoCollectionViewCell.self,
            forCellWithReuseIdentifier: TodoCollectionViewCell.identifier
        )
    }

    func dequeueTodoCollectionViewCell(indexPath: IndexPath) -> TodoCollectionViewCell {
        return dequeueReusableCell(
            withReuseIdentifier: TodoCollectionViewCell.identifier,
            for: indexPath
        ) as! TodoCollectionViewCell
    }
}
