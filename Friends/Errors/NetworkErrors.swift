//
//  NetworkErrors.swift
//  Friends
//
//  Created by Савва Пономарев on 02.04.2025.
//

import Foundation

enum NetworkError: Error {
    case download
    case upload
    case custom(errorCode: Int, description: String)

    var localizedDescription: String {
        switch self {
        case .download:
            return "Download failed"
        case .upload:
            return "Upload failed"
        case .custom(_, let description):
            return description
        }
    }
}
