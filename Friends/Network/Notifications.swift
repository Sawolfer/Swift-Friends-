//
//  Notifications.swift
//  Friends
//
//  Created by Савва Пономарев on 31.03.2025.
//

import Foundation
import Firebase

class Notifications {

    // MARK: - User Account Interactions

    func saveFCMToken(for userId: String, token: String) {
        let db = Firestore.firestore()
        db.collection("users").document(userId).setData(["fcmToken": token], merge: true) { error in
            if let error = error {
                print("Error saving FCM token: \(error.localizedDescription)")
            } else {
                print("FCM token saved successfully")
            }
        }
    }
    func getFCMTokens(for userIds: [String], completion: @escaping ([String]) -> Void) {
        let db = Firestore.firestore()
        var tokens: [String] = []

        let group = DispatchGroup()

        userIds.forEach { userId in
            group.enter()
            db.collection("users").document(userId).getDocument { document, _ in
                if let token = document?.data()?["fcmToken"] as? String {
                    tokens.append(token)
                }
                group.leave()
            }
        }

        group.notify(queue: .main) {
            completion(tokens)
        }
    }

    // MARK: - Send Notification

    func sendFCMMessage(to tokens: [String], title: String, body: String) {
        guard let url = URL(string: "https://your-cloud-function-url/sendNotification") else { return }

        let payload: [String: Any] = [
            "tokens": tokens,
            "title": title,
            "body": body
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: payload, options: .prettyPrinted)
        } catch {
            print("Error encoding payload: \(error.localizedDescription)")
            return
        }

        URLSession.shared.dataTask(with: request) { _, _, error in
            if let error = error {
                print("Error sending notification: \(error.localizedDescription)")
            } else {
                print("Notification sent successfully")
            }
        }.resume()
    }
}
