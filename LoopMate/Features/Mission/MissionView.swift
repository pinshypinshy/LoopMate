//
//  MissionView.swift
//  LoopMate
//
//  Created by 平石悠生 on 2026/03/03.
//

import SwiftUI

struct MissionView: View {
    
    let missions: [TodayAllRoomsMissionData] = [
        TodayAllRoomsMissionData(id: "room_001_user_001", roomID: "room_001", roomName: "TOEIC勉強", isCompleted: false),
        TodayAllRoomsMissionData(id: "room_002_user_001", roomID: "room_002", roomName: "筋トレ", isCompleted: true)
    ]
    
    var incompleteMissions: [TodayAllRoomsMissionData] {
        missions.filter { !$0.isCompleted }
    }

    var completedMissions: [TodayAllRoomsMissionData] {
        missions.filter { $0.isCompleted }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.orange).opacity(0.1).ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 18) {
                        
                        Text("未実施")
                            .font(.headline)
                            .padding(.horizontal, 4)

                        VStack(spacing: 18) {
                            ForEach(incompleteMissions) { mission in
                                MissionCellView(mission: mission)
                            }
                        }
                        
                        Text("実施済み")
                            .font(.headline)
                            .padding(.horizontal, 4)
                            .padding(.top, 8)
                        
                        VStack(spacing: 18) {
                            ForEach(completedMissions) { mission in
                                MissionCellView(mission: mission)
                                    .opacity(0.6)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle("今日のミッション")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button {
                        
                    } label: {
                        Image(systemName: "bell")
                    }
                }
            }
        }
    }
}

#Preview {
    MissionView()
}
