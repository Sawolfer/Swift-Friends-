//
//  FileError.swift
//  Friends
//
//  Created by Савва Пономарев on 03.04.2025.
//

import Foundation

enum File: Error {
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
