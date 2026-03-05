//
//  User.swift
//  LoopMate
//
//  Created by 平石悠生 on 2026/03/05.
//

import Foundation

struct User: Identifiable {
    let id: String
    let name: String
    let friends: [String] = []
    let iconURL: URL? = nil
}

extension User {
    static let preview = User(id: "testuser", name: "プレビュー用")
}
