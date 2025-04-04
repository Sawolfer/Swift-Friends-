//
//  AuthentificationViewModel.swift
//  Friends
//
//  Created by тимур on 03.04.2025.
//

import Foundation

final class AuthViewModel: ObservableObject {
    enum Mode {
        case login
        case registration
    }

    @Published var mode: Mode = .login
    @Published var name = ""
    @Published var username = ""
    @Published var password = ""
    @Published var errorMessage = ""
    @Published var showErrorAlert = false

    private let authProvider = AuthNetwork()
    private let userCache = UserDataCache()

    var onAuthSuccess: (() -> Void)?

    func authenticate() {
        if username.isEmpty {
            errorMessage = "Enter username"
            showErrorAlert = true
            return
        }

        if password.isEmpty {
            errorMessage = "Enter password"
            showErrorAlert = true
            return
        }

        if mode == .registration {
            if name.isEmpty {
                errorMessage = "Enter name"
                showErrorAlert = true
                return
            }

            authProvider.checkNameAvailability(name: username) { [weak self] result in
                switch result {
                case .success(let isAvailable):
                    if !isAvailable {
                        self?.errorMessage = "Username already taken"
                        self?.showErrorAlert = true
                        return
                    }
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    self?.showErrorAlert = true
                    return
                }
            }

            authProvider.createAccount(name: name, username: username, password: password) { [weak self] result in
                switch result {
                case .success(let person):
                    print("Account created")
                    AppCache.shared.user = person
                    self?.userCache.saveUserInfo(userInfo: ["username": self?.username ?? "", "password": self?.password ?? ""])

                    DispatchQueue.main.async {
                        self?.onAuthSuccess?()
                    }
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    self?.showErrorAlert = true
                }
            }
        } else {
            authProvider.login(name: name, password: password) { [weak self] result in
                switch result {
                case .success(let person):
                    print("Login success")
                    AppCache.shared.user = person
                    self?.userCache.saveUserInfo(userInfo: ["username": self?.username ?? "", "password": self?.password ?? ""])

                    DispatchQueue.main.async {
                        self?.onAuthSuccess?()
                    }
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    self?.showErrorAlert = true
                }
            }
        }
    }
}
