//
//  Room.swift
//  LoopMate
//
//  Created by 平石悠生 on 2026/03/03.
//

import Foundation

struct Room: Identifiable {
    let id: String
    let name: String
    let code: String
    let memberCount: Int
    let progress: Int
}

extension Room {
    static let preview = Room(
        id: "preview",
        name: "テストルーム",
        code: "ABC12",
        memberCount: 5,
        progress: 99
    )
    
    var progressText: String {
        "今月の達成状況 \(progress)%"
    }
}
