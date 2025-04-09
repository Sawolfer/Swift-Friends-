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

    // MARK: - Cache

    var user: Person?

    // MARK: - App Data

    var events: [EventModels.Event] = []
    var debts: [Debt] = []
    var friends: [Person] = []
    var icons: [UUID: URL] = [:]

    private var fileManager: FileManager
    private var fileName = "friends.json"
    private let cacheURL: URL

    private init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
        let cacheDirectory = FileManager.default.urls(
            for: .cachesDirectory, in: .userDomainMask
        ).first

        cacheURL = cacheDirectory!.appendingPathComponent("app_data.json")
    }

    // MARK: - Public Functions

    func save(completion: @escaping ((Result<Bool, FileError>) -> Void)) {
        guard let currentUser = user else {
            completion(
                .failure(.custom(errorCode: 400, description: "User not set")))
            return
        }

        let appData = AppData(
            user: currentUser,
            events: events,
            debts: debts,
            friends: friends,
            icons: icons
        )
        do {
            try saveData(appData)
            completion(.success(true))
        } catch {
            completion(
                .failure(
                    .custom(errorCode: 312, description: "Error saving data")))
        }
    }

    func load(completion: @escaping ((Result<AppData, AuthError>) -> Void)) {
        do {
            loadData { result in
                switch result {
                case .success(let appData):
                    self.insertLoadedData(appData)
                    completion(.success(appData))
                case .failure(let error):
                    completion(
                        .failure(
                            .custom(
                                errorCode: 315,
                                description:
                                    "Error while saving loaded data, \(error)"))
                    )
                }
            }
        }
    }

    func clear(completion: @escaping ((Result<Bool, AuthError>) -> Void)) {
        do {
            try clearData()
            completion(.success(true))
        } catch {
            completion(
                .failure(
                    .custom(
                        errorCode: 315, description: "Error while cleaning data"
                    )))
        }
    }

    // MARK: - Privat Functions

    private func saveData(_ data: AppData) throws {
        let jsonData = try JSONEncoder().encode(data)
        try createCacheDirectoryIfNeeded()
        try jsonData.write(to: cacheURL)
    }

    private func loadData(
        completion: @escaping ((Result<AppData, AuthError>) -> Void)
    ) {
        guard fileManager.fileExists(atPath: cacheURL.path) else {
            completion(
                .failure(
                    .custom(errorCode: 313, description: "Cache file not found")
                ))
            return
        }

        do {
            let jsonData = try Data(contentsOf: cacheURL)
            let decodedData = try JSONDecoder().decode(
                AppData.self, from: jsonData)
            completion(.success(decodedData))
        } catch {
            completion(
                .failure(
                    .custom(
                        errorCode: 314,
                        description:
                            "Failed to load or decode data: \(error.localizedDescription)"
                    )))
        }
    }

    private func insertLoadedData(_ data: AppData) {
        self.user = data.user
        self.events = data.events
        self.debts = data.debts
        self.friends = data.friends
        self.icons = data.icons
    }

    private func clearData() throws {
        user = nil
        events = []
        debts = []
        friends = []
        icons = [:]

        if fileManager.fileExists(atPath: cacheURL.path) {
            try fileManager.removeItem(at: cacheURL)
        }
    }

    private func createCacheDirectoryIfNeeded() throws {
        let directoryURL = cacheURL.deletingLastPathComponent()
        if !fileManager.fileExists(atPath: directoryURL.path) {
            try fileManager.createDirectory(
                at: directoryURL, withIntermediateDirectories: true)
        }
    }
}
