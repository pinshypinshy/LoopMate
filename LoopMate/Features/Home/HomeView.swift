//
//  HomeView.swift
//  LoopMate
//
//  Created by 平石悠生 on 2026/03/03.
//

import SwiftUI

private enum AppRoute: Hashable {
    case roomCreationFlow
    case createdRoom
    case roomEnter
    case joinedRoom
}

struct HomeView: View {
    
    let rooms: [Room] = [
        Room(id: "room_001", name: "TOEIC勉強", code: "K53VM", memberCount: 3, progress: 76),
        Room(id: "room_002", name: "筋トレ", code: "G6LK9", memberCount: 2, progress: 52)
    ]
    
    @State private var isFabMenuOpen = false
    @State private var path: [AppRoute] = []
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack(alignment: .bottomTrailing) {
                Color(.orange).opacity(0.1).ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 18) {
                        ForEach(rooms) { room in
                            NavigationLink(destination: RoomView()) {
                                RoomCellView(room: room)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top)
                }
                
                if isFabMenuOpen {
                    RoomAddMenuView(
                        onCreate: {
                            isFabMenuOpen = false
                            path.append(.roomCreationFlow)
                        },
                        onJoin: {
                            isFabMenuOpen = false
                            print("ルームに入る")
                            path.append(.roomEnter)
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
            .navigationDestination(for: AppRoute.self) { route in
                switch route {
                case .roomCreationFlow:
                    RoomCreationFlowHostView(
                        onCreateCompleted: {
                            path.append(.createdRoom)
                        }
                    )
                    
                case .createdRoom:
                    RoomView(
                        onBack: {
                            path.removeAll()
                        },
                        shouldShowCompletionOnAppear: true
                    )
                    
                case .roomEnter:
                    RoomEnterView(
                        onJoin: {
                            
                            path.append(.joinedRoom)
                        }
                    )
                    
                case .joinedRoom:
                    RoomView(
                        onBack: {
                            path.removeAll()
                        }
                    )
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
