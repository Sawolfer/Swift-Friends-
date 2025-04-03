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
        }
    }
}
