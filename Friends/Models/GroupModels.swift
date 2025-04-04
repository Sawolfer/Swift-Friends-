//
//  GroupModels.swift
//  Friends
//
//  Created by Алексей on 02.04.2025.
//

import UIKit

enum GroupModels {
    struct Group: Hashable {
        var id: UUID
        var title: String
        var friends: [Person]
    }
}
