//
//  TodayAllRoomsMissionData.swift
//  LoopMate
//
//  Created by 平石悠生 on 2026/03/05.
//

import Foundation

struct TodayAllRoomsMissionData: Identifiable {
    let id: String
    let roomID: String
    let roomName: String
    let isCompleted: Bool
}

extension TodayAllRoomsMissionData {
    static let preview = TodayAllRoomsMissionData(
        id: "preview", roomID: "room_000", roomName: "プレビュー", isCompleted: false
    )
}
