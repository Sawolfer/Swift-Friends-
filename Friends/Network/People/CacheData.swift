//
//  CacheData.swift
//  Friends
//
//  Created by Савва Пономарев on 03.04.2025.
//

import Foundation
import Security

class CahcheUserInfo {

    private let service = "sirius.Friends.cacheinfo"
    private let account = "userCredentials"

    func saveUserInfo(userInfo: [String: Any]) {
        guard
            let username = userInfo["username"] as? String,
            let password = userInfo["password"] as? String
        else {
            return
        }
        let userData: [String: Any] = [
            "username": username,
            "password": password
        ]
        guard let credentialsData = try? JSONSerialization.data(withJSONObject: userData) else {
            return
        }
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecValueData as String: credentialsData
        ]
        SecItemDelete(query as CFDictionary)

        let status = SecItemAdd(query as CFDictionary, nil)
    }

    func retrieveUserInfo() -> [String: Any]? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)

        guard status == errSecSuccess, let retrievedData = dataTypeRef as? Data else {
            return nil
        }

        return try? JSONSerialization.jsonObject(with: retrievedData, options: []) as? [String: Any]
    }

    func deleteUserInfo() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]

        SecItemDelete(query as CFDictionary)
    }
}
