//
//  AppCache.swift
//  Friends
//
//  Created by Савва Пономарев on 03.04.2025.
//

import Foundation

struct AppData: Codable {
    var user: Person
    var events: [EventModels.Event]
    var debts: [Debt]
    var friends: [Person]
    var icons: [UUID: URL]
}

class AppCache {
    static let shared = AppCache()

    var user: Person?
    var appData: AppData?
    private var fileManager: FileManager
    private var fileName = "friends.json"
    private let cacheURL: URL

    private init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
        let cacheDirectory = FileManager.default.urls(
            for: .cachesDirectory, in: .userDomainMask
        ).first!
        cacheURL = cacheDirectory.appendingPathComponent("app_data.json")
    }

    func saveAppData(
        _ data: AppData,
        completion: @escaping ((Result<Bool, AuthError>) -> Void)
    ) {
        do {
            let jsonData = try JSONEncoder().encode(data)
            try jsonData.write(to: cacheURL)
            user = data.user
            completion(.success(true))
        } catch {
            completion(
                .failure(
                    .custom(errorCode: 520, description: "Data saving failed")))
        }
    }

    func loadAppData(
        completion: @escaping ((Result<AppData, AuthError>) -> Void)
    ) {
        do {
            let jsonData = try Data(contentsOf: cacheURL)
            let data = try JSONDecoder().decode(AppData.self, from: jsonData)
            user = data.user

            completion(
                .success(data)
            )
        } catch {
            completion(.failure(.login))
        }
    }
    func clearCache(completion: @escaping ((Result<Bool, AuthError>) -> Void)) {
        do {
            try FileManager.default.removeItem(at: cacheURL)
            completion(.success(true))
        } catch {
            completion(
                .failure(
                    .custom(errorCode: 520, description: "Data clearing failed")
                ))
        }
    }
}
