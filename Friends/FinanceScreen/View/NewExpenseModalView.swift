//
//  NewExpenseModalView.swift
//  Friends
//
//  Created by Алёна Максимова on 01.04.2025.
//

import UIKit
import SnapKit

final class NewExpenseModalView: UIView {

    // MARK: - Properties

    private(set) lazy var totalTextField: UITextField = {
        let textField = UITextField()
        textField.text = "1000₽"
        textField.font = UIFont.systemFont(ofSize: 64, weight: .light)
        textField.textColor = .systemBlue
        textField.textAlignment = .center
        textField.borderStyle = .none
        textField.backgroundColor = .clear

        return textField
    }()

    private(set) lazy var splitButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.title = "Разделить поровну"
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.systemFont(ofSize: 15, weight: .bold)
            outgoing.foregroundColor = .systemBlue
            return outgoing
        }

        let chevron = UIImage(systemName: "chevron.up.chevron.down")?.withTintColor(.systemBlue).withConfiguration(UIImage.SymbolConfiguration(pointSize: 15))
        configuration.image = chevron
        configuration.imagePlacement = .trailing
        configuration.imagePadding = 6

        let button = UIButton(configuration: configuration, primaryAction: nil)

        return button
    }()

    private(set) lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(PersonCell.self, forCellReuseIdentifier: PersonCell.personCellIdentifier)
        tableView.keyboardDismissMode = .onDrag
        tableView.backgroundColor = .background
        tableView.separatorStyle = .none

        return tableView
    }()

    // MARK: - Initializers

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupView() {
        [totalTextField, tableView].forEach(self.addSubview)
    }

    // MARK: - Constraints

    override func layoutSubviews() {
        super.layoutSubviews()

        totalTextField.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(150)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(totalTextField.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(60)
        }
    }
}
