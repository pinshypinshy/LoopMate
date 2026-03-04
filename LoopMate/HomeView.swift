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
    
    @State private var isFabMenuOpen = false
    
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
                
                if isFabMenuOpen {
                    RoomAddMenuView(
                        onCreate: {
                            isFabMenuOpen = false
                            print("ルームを作る")
                            // TODO: 画面遷移など
                        },
                        onJoin: {
                            isFabMenuOpen = false
                            print("ルームに入る")
                            // TODO: 画面遷移など
                        }
                    )
                    .padding(.trailing, 20)
                    .padding(.bottom, 20 + 80)
                }
                
                FloatingPlusButton {
                    withAnimation(.spring(response: 0.25, dampingFraction: 0.85)) {
                        isFabMenuOpen.toggle()
                    }
                }
                .padding(.trailing, 20)
                .padding(.bottom, 20)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                if isFabMenuOpen {
                    withAnimation(.easeOut(duration: 0.15)) {
                        isFabMenuOpen = false
                    }
                }
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
