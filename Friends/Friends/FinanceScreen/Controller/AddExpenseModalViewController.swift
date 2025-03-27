//
//  AddExpenseModalViewController.swift
//  Friends
//
//  Created by Алёна Максимова on 26.03.2025.
//

import UIKit

final class AddExpenseModalViewController: UIViewController {
    
    var isSearchActive : Bool = false
    var isAllPeopleShown: Bool = true
    
    var people: [Person] = [Person (name: "kizaru", debt: 1000),
                            Person(name: "Alyona", debt: 10)]
    var filteredPeople: [Person] = []
    var selectedPeople: [Person] = []
    
    private var expenseView: AddExpenseModalView {
        guard let view = view as? AddExpenseModalView else {
            fatalError()
        }
        return view
    }
    
    override func loadView() {
        self.view = AddExpenseModalView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        expenseView.backgroundColor = .systemGray6
        
        expenseView.individualView.searchBar.delegate = self
        expenseView.individualView.tableView.dataSource = self
        expenseView.individualView.tableView.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        expenseView.addGestureRecognizer(tapGesture)
        
        expenseView.typeExpenseControl.addTarget(self, action: #selector(changeTypeExpense), for: .valueChanged)
        
        expenseView.individualView.addButton.addTarget(self, action: #selector(showAllPeople), for: .touchUpInside)
    }
    
    @objc func showAllPeople() {
        isAllPeopleShown = true
        expenseView.individualView.addButton.isHidden = isAllPeopleShown
        expenseView.individualView.tableView.reloadData()
    }
    
    @objc func changeTypeExpense() {
        expenseView.toggleViews()
    }
    
    @objc func hideKeyboard() {
        expenseView.endEditing(true)
    }
}

extension AddExpenseModalViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        isSearchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        isSearchActive = false;
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredPeople = people.filter({ (person) -> Bool in
            let tmp = NSString(string: person.name)
            let range = tmp.range(of: searchText, options:.caseInsensitive)
            return range.location != NSNotFound
        })
        
        if (filteredPeople.count == 0) {
            isSearchActive = false;
        } else {
            isSearchActive = true;
        }
        
        expenseView.individualView.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
            fatalError("Failed to dequeue EmployeeCell")
        }
        
        var person: Person!
        if (isSearchActive && !filteredPeople.isEmpty) {
            person = filteredPeople[indexPath.row]
            cell.configure(with: person)
        } else if isAllPeopleShown {
            person = people[indexPath.row]
            cell.configure(with: person)
        } else {
            person = selectedPeople[indexPath.row]
            cell.configure(with: person, isEditable: !isAllPeopleShown, resetTextField: true)
        }
    
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

extension AddExpenseModalViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if isAllPeopleShown {
            selectedPeople.append(people[indexPath.row])
            isAllPeopleShown = false
            expenseView.individualView.addButton.isHidden = isAllPeopleShown
        }
        tableView.reloadData()
    }
    
   func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            selectedPeople.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            if selectedPeople.isEmpty { // как лучше сделать переход? анимация или задержка на главном потоке?
                isAllPeopleShown = true
                expenseView.individualView.addButton.isHidden = isAllPeopleShown
                tableView.reloadData()
            }
        }
    }
}
