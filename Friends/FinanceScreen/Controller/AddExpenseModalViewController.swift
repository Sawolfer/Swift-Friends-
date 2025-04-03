//
//  AddExpenseModalViewController.swift
//  Friends
//
//  Created by Алёна Максимова on 26.03.2025.
//

import UIKit

protocol AddExpenseModalViewControllerDelegate: AnyObject {
    func updateSelectedPersonDebt(person: Person?)
}

final class AddExpenseModalViewController: UIViewController {

    // MARK: - Properties

    var isSearchActive: Bool = false
    var isAllPeopleShown: Bool = true

    let people: [Person] = []
    var filteredPeople: [Person] = []
    var selectedPeople: Set<Person> = []

    private var expenseView: AddExpenseModalView {
        guard let view = view as? AddExpenseModalView else {
            assertionFailure("Failed to dequeue PersonCell") // Логируем ошибку для отладки
            return AddExpenseModalView()
        }
        return view
    }

    // MARK: - Lifecycle

    override func loadView() {
        self.view = AddExpenseModalView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
    }

    // MARK: - Setup Methods

    private func setupUI() {
        expenseView.backgroundColor = .systemGray6
        expenseView.individualView.searchBar.delegate = self
        expenseView.individualView.tableView.dataSource = self
        expenseView.individualView.tableView.delegate = self
    }

    private func setupActions() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        expenseView.addGestureRecognizer(tapGesture)

        expenseView.typeExpenseControl.addTarget(self, action: #selector(changeTypeExpense), for: .valueChanged)
        expenseView.individualView.addButton.addTarget(self, action: #selector(showAllPeople), for: .touchUpInside)
    }

    // MARK: - Actions

    @objc private func showAllPeople() {
        isAllPeopleShown = true
        expenseView.individualView.addButton.isHidden = isAllPeopleShown
        expenseView.individualView.tableView.reloadData()
    }

    @objc private func changeTypeExpense() {
        expenseView.toggleViews()
    }

    @objc private func hideKeyboard() {
        expenseView.endEditing(true)
    }
}
extension AddExpenseModalViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearchActive = true
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        isSearchActive = false
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearchActive = false
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        isSearchActive = false
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        filteredPeople = people.filter({ (person) -> Bool in
            let tmp = NSString(string: person.name)
            let range = tmp.range(of: searchText, options: .caseInsensitive)
            return range.location != NSNotFound
        })

        if filteredPeople.isEmpty {
            isSearchActive = false
        } else {
            isSearchActive = true
        }

        expenseView.individualView.tableView.reloadData()
    }
}

extension AddExpenseModalViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearchActive {
            return filteredPeople.count
        } else if isAllPeopleShown {
            return people.count
        }
        return selectedPeople.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: PersonCell.personCellIdentifier,
            for: indexPath
        ) as? PersonCell else {
            assertionFailure("Failed to dequeue PersonCell")
            return UITableViewCell()
        }

        var person: Person!
        if isSearchActive && !filteredPeople.isEmpty {
            person = filteredPeople[indexPath.row]
            cell.configure(with: person, isDebitor: true)
        } else if isAllPeopleShown {
            person = people[indexPath.row]
            cell.configure(with: person, isDebitor: false)
        } else {
            var resetTextField = false
            person = selectedPeople[selectedPeople.index(selectedPeople.startIndex, offsetBy: indexPath.row)]

            if selectedPeople.contains(where: { $0.id == person.id && person.isSelectedFirstTime }) {
                person.isSelectedFirstTime = false
                resetTextField = true
            }

            cell.configure(with: person, isDebitor: true, isEditable: !isAllPeopleShown, resetTextField: resetTextField)
        }
        cell.delegate = self

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        TODO: вынести в константу

        return 80
    }
}

extension AddExpenseModalViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if isAllPeopleShown {
            if !selectedPeople.contains(where: { $0.id == people[indexPath.row].id }) {
                selectedPeople.insert(people[indexPath.row])
            }
            isAllPeopleShown = false
            expenseView.individualView.addButton.isHidden = isAllPeopleShown
        }
        tableView.reloadData()
    }

   func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            selectedPeople.remove(at: selectedPeople.index(selectedPeople.startIndex, offsetBy: indexPath.row))
            tableView.deleteRows(at: [indexPath], with: .fade)
//          TODO: как лучше сделать переход? анимация или задержка на главном потоке?
            if selectedPeople.isEmpty {
                isAllPeopleShown = true
                expenseView.individualView.addButton.isHidden = isAllPeopleShown
                tableView.reloadData()
            }
        }
    }
}

extension AddExpenseModalViewController: AddExpenseModalViewControllerDelegate {
    func updateSelectedPersonDebt(person: Person?) {
        guard let newPerson = person, let oldPersonIndex = selectedPeople.firstIndex(where: { $0.id == newPerson.id }) else { return }
        selectedPeople.remove(at: oldPersonIndex)
        selectedPeople.insert(newPerson)
    }
}
