//
//  HomeView.swift
//  LoopMate
//
//  Created by 平石悠生 on 2026/03/03.
//

import SwiftUI

struct HomeView: View {
    
    let rooms: [Room] = [
        Room(id: "room_001", name: "テストルーム1", code: "K53VM", memberCount: 3, progress: 76),
        Room(id: "room_002", name: "テストルーム2", code: "G6LK9", memberCount: 2, progress: 52)
    ]
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                Color(.orange).opacity(0.1).ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 18) {
                        ForEach(rooms) { room in
                            RoomCellView(room: room)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top)
                }
                
                FloatingPlusButton {
                    
                }
                .padding(.trailing, 20)
                .padding(.bottom, 20)
            }
            .navigationTitle("ホーム")
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
    HomeView()
}
