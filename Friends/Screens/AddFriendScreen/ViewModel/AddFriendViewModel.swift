//
//  AddFriendViewModel.swift
//  Friends
//
//  Created by тимур on 03.04.2025.
//

import Foundation

final class AddFriendViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var users = [Person]()
    @Published var errorMessage = ""
    @Published var isLoading: Bool = false

    private let peopleProvider = PeopleNetwork()

    func searchUsers() {
        peopleProvider.findUser(by: searchText) { [weak self] result in
            switch result {
            case .success(let persons):
                self?.users = persons
            case .failure(let error):
                self?.errorMessage = error.localizedDescription
            }
        }
    }
}
