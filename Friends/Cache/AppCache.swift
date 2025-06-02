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
    static let initialUser = Person(
        id: UUID(),
        name: "init",
        username: "init",
        password: "init",
        debts: []
    )
    static var shared = AppCache(user: initialUser)

    // MARK: - Cache Properties

    private var _user: Person
    var user: Person {
        get { _user }
        set {
            _user = newValue

        }
    }

    // MARK: - App Data

    var events: [EventModels.Event] = []
    var debts: [Debt] = []
    var friends: [Person] = []
    var icons: [UUID: URL] = [:]

    // MARK: - Private Properties

    private var fileManager: FileManager
    private let cacheURL: URL

    // MARK: - Initialization

    init(user: Person, fileManager: FileManager = .default) {
        self._user = user
        self.fileManager = fileManager
        let cacheDirectory = fileManager.urls(
            for: .cachesDirectory, in: .userDomainMask
        ).first!

        cacheURL = cacheDirectory.appendingPathComponent("app_data.json")
    }

    // MARK: - Public Functions

    func save(completion: @escaping ((Result<Bool, FileError>) -> Void)) {
        let appData = AppData(
            user: self.user,
            events: self.events,
            debts: self.debts,
            friends: self.friends,
            icons: self.icons
        )

        do {
            try saveData(appData)
            completion(.success(true))
        } catch {
            completion(.failure(.custom(errorCode: 312, description: "Error saving data")))
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
                    completion(.failure(.custom(
                        errorCode: 315,
                        description: "Error while saving loaded data, \(error)"
                    )))
                }
            }
        }
    }

    func clear(completion: @escaping ((Result<Bool, AuthError>) -> Void)) {
        do {
            try clearData()
            completion(.success(true))
        } catch {
            completion(.failure(.custom(
                errorCode: 315,
                description: "Error while cleaning data"
            )))
        }
    }

    // MARK: - Private Functions

    private func saveData(_ data: AppData) throws {
        let jsonData = try JSONEncoder().encode(data)
        try createCacheDirectoryIfNeeded()
        try jsonData.write(to: cacheURL)
    }

    private func loadData(completion: @escaping ((Result<AppData, AuthError>) -> Void)) {
        guard fileManager.fileExists(atPath: cacheURL.path) else {
            completion(.failure(.custom(
                errorCode: 313,
                description: "Cache file not found"
            )))
            return
        }

        do {
            let jsonData = try Data(contentsOf: cacheURL)
            let decodedData = try JSONDecoder().decode(AppData.self, from: jsonData)
            completion(.success(decodedData))
        } catch {
            completion(.failure(.custom(
                errorCode: 314,
                description: "Failed to load or decode data: \(error.localizedDescription)"
            )))
        }
    }

    private func insertLoadedData(_ data: AppData) {
        self._user = data.user
        self.events = data.events
        self.debts = data.debts
        self.friends = data.friends
        self.icons = data.icons
    }

    private func clearData() throws {
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
                at: directoryURL,
                withIntermediateDirectories: true
            )
        }
    }
}

extension AppCache {
    static func setupShared(user: Person) {
        shared = AppCache(user: user)
    }
}
