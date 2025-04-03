//
//  NewExpenseModalViewController.swift
//  Friends
//
//  Created by Алёна Максимова on 01.04.2025.
//

import UIKit
import SwiftUI

// MARK: - Protocols

protocol NewExpenseModalViewControllerDelegate: AnyObject {
    func updateSelectedPersonDebt(personId: UUID, debt: Double)
}

final class NewExpenseModalViewController: UIViewController {

    // MARK: - Properties

    private var isSplitEven: Bool = true
    private var debts: [Double] = []
    private var friends: [Person] = [] {
        didSet {
            var newDebts: [Double] = []
            for friend in friends {
                if let index = oldValue.firstIndex(where: { $0.id == friend.id }) {
                    newDebts.append(debts[index])
                } else {
                    newDebts.append(0)
                }
            }
            debts = newDebts
            expenseView.tableView.reloadData()
            updateDebts()
            updateAddButtonState()
        }
    }

    private var expenseView: NewExpenseModalView {
        guard let view = view as? NewExpenseModalView else {
            assertionFailure("Failed to dequeue PersonCell")
            return NewExpenseModalView()
        }
        return view
    }

    // MARK: - Lifecycle

    override func loadView() {
        self.view = NewExpenseModalView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        setupNavigationBar()
        updateDebts()
    }

    // MARK: - Setup Methods

    private func setupUI() {
        expenseView.backgroundColor = .background
        expenseView.totalTextField.delegate = self
        expenseView.tableView.delegate = self
        expenseView.tableView.dataSource = self
    }

    private func setupActions() {
        setupSplitButton()
    }

    private func setupNavigationBar() {
        navigationItem.title = "Новая трата"
        let cancelButton = UIBarButtonItem(title: "Отмена",
                                           primaryAction: UIAction { [weak self] _ in
            self?.dismiss(animated: true)
        })

        let addButton = UIBarButtonItem(title: "Добавить",
                                        primaryAction: UIAction { [weak self] _ in
            self?.dismiss(animated: true)
        })

        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = addButton

        cancelButton.tintColor = .systemRed
        addButton.tintColor = .systemGray
        addButton.isEnabled = false
    }

    private func setupSplitButton() {
        let splitEvenAction = UIAction(
            title: "Разделить поровну",
            image: UIImage(systemName: "person.2.fill"),
            state: isSplitEven ? .on : .off
        ) { [weak self] _ in
            self?.handleSplitEvenSelection()
        }

        let enterManuallyAction = UIAction(
            title: "Ввести вручную",
            image: UIImage(systemName: "pencil"),
            state: isSplitEven ? .off : .on
        ) { [weak self] _ in
            self?.handleManualEntrySelection()
        }

        let menu = UIMenu(title: "", children: [splitEvenAction, enterManuallyAction])

        expenseView.splitButton.showsMenuAsPrimaryAction = true
        expenseView.splitButton.menu = menu
    }

    private func handleSplitEvenSelection() {
        isSplitEven = true
        expenseView.totalTextField.isEnabled = true
        expenseView.splitButton.setTitle("Разделить поровну", for: .normal)
        updateDebts()
        setupSplitButton()
        expenseView.tableView.reloadData()
    }

    private func handleManualEntrySelection() {
        isSplitEven = false
        expenseView.totalTextField.isEnabled = false
        expenseView.splitButton.setTitle("Ввести вручную", for: .normal)
        updateDebts()
        setupSplitButton()
        expenseView.tableView.reloadData()
    }

    private func updateDebts() {
        guard let totalText = expenseView.totalTextField.text?.replacingOccurrences(of: "₽", with: ""), let totalAmount = Double(totalText) else { return }

        if isSplitEven {
            let splitAmount = totalAmount / Double(friends.count)
            debts = Array(repeating: splitAmount, count: friends.count)
            expenseView.tableView.reloadData()
        } else {
            let total = debts.reduce(0, +)
            expenseView.totalTextField.text = "\(total)₽"
        }
    }
}

// MARK: - Extensions

extension NewExpenseModalViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PersonCell.personCellIdentifier, for: indexPath) as? PersonCell else {
            return UITableViewCell()
        }
        let person = friends[indexPath.row]
        cell.configure(with: person, isDebitor: true, isEditable: !isSplitEven, resetTextField: false)
        cell.debtTextFieldView.text = debts[indexPath.row].description
        cell.delegate = self

        if indexPath.row == 0 {
            cell.layer.cornerRadius = 10
            cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            cell.clipsToBounds = true
        }

        return cell
    }
}

extension NewExpenseModalViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()

        let titleLabel = UILabel()
        titleLabel.text = "Друзья"
        titleLabel.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        titleLabel.textColor = .systemGray
        headerView.addSubview(titleLabel)

        headerView.addSubview(expenseView.splitButton)

        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
        }

        expenseView.splitButton.snp.remakeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(30)
        }

        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 34
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 44))
        footerView.backgroundColor = .white
        let addFriendButton = UIButton(type: .system)
        addFriendButton.setTitle("Добавить друзей", for: .normal)
        addFriendButton.setTitleColor(.systemBlue, for: .normal)
        addFriendButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        addFriendButton.addAction(
            UIAction { [weak self] _ in
                let selectedFriendsBinding = Binding<[Person]>(
                    get: { self?.friends ?? [] },
                    set: { self?.friends = $0 }
                )

                let selectFriendsView = SelectFriendsViewExpence(
                    friends: PersonContainer.shared.getPeople(),
                    selectedFriends: selectedFriendsBinding
                )
                let hostingController = UIHostingController(rootView: selectFriendsView)
                self?.present(hostingController, animated: true)
            },
            for: .touchUpInside
        )
        footerView.addSubview(addFriendButton)

        addFriendButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }

        footerView.layer.cornerRadius = 10

        if !friends.isEmpty {
            footerView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        }

        return footerView
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 44
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension NewExpenseModalViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text?.last != "₽", let textFieldText = textField.text {
            textField.text = textFieldText.isEmpty ? "" : "\(textFieldText)₽"
        }
        updateAddButtonState()
        updateDebts()
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        updateAddButtonState()
        updateDebts()
    }

    private func updateAddButtonState() {
        if let text = expenseView.totalTextField.text, !text.isEmpty, text.count > 1, text != "0₽", !debts.contains(where: { $0 == 0 }), !friends.isEmpty {
            navigationItem.rightBarButtonItem?.isEnabled = true
            navigationItem.rightBarButtonItem?.tintColor = .systemBlue
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = false
            navigationItem.rightBarButtonItem?.tintColor = .systemGray
        }
    }
}

extension NewExpenseModalViewController: NewExpenseModalViewControllerDelegate {
    func updateSelectedPersonDebt(personId: UUID, debt: Double) {
        guard let person = friends.first(where: { $0.id == personId }), let index = friends.firstIndex(of: person) else { return }

        debts[index] = debt
        updateDebts()
        updateAddButtonState()
    }
}
