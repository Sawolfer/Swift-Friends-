//
//  AuthificactionError.swift
//  Friends
//
//  Created by Савва Пономарев on 03.04.2025.
//

import Foundation

enum AuthError: Error {
    case auth
    case login
    case custom(errorCode: Int, description: String)

    var localizedDescription: String {
        switch self {
        case .auth:
            return "Authentication failed"
        case .login:
            return "Login failed"
        case .custom(_, let description):
            return description
        }
    }
}
