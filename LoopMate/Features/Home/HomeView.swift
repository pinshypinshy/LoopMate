//
//  HomeView.swift
//  LoopMate
//
//  Created by 平石悠生 on 2026/03/03.
//

import SwiftUI

private enum AppRoute: Hashable {
    case roomCreationFlow
    case createdRoom(roomId: String)
    case roomEnter
    case joinedRoom(roomId: String)
}

struct HomeView: View {
    
//    let rooms: [Room] = [
//        Room(id: "room_001", name: "TOEIC勉強", code: "K53VM", memberCount: 3, progress: 76),
//        Room(id: "room_002", name: "筋トレ", code: "G6LK9", memberCount: 2, progress: 52)
//    ]
    
    @State private var rooms: [Room] = []
    @State private var isFabMenuOpen = false
    @State private var path: [AppRoute] = []
    @State private var isLoadingRooms = false
    @State private var errorMessage = ""
    @State private var showErrorAlert = false
    
    private let roomService = RoomService()
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack(alignment: .bottomTrailing) {
                Color(.orange).opacity(0.1).ignoresSafeArea()
                
                ScrollView {
                    ScrollView {
                        if isLoadingRooms {
                            ProgressView("読み込み中...")
                                .frame(maxWidth: .infinity)
                                .padding(.top, 40)
                        } else if rooms.isEmpty {
                            Text("参加中のルームはまだありません")
                                .foregroundStyle(.secondary)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.top, 40)
                        } else {
                            VStack(spacing: 18) {
                                ForEach(rooms) { room in
                                    NavigationLink(destination: RoomView(roomId: room.id)) {
                                        HomeRoomCellView(room: room)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.horizontal)
                            .padding(.top)
                        }
                    }
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
                        onCreateCompleted: { roomId in
                            path.append(.createdRoom(roomId: roomId))
                        }
                    )
                    
                case .createdRoom(let roomId):
                    RoomView(
                        roomId: roomId,
                        onBack: {
                            path.removeAll()
                            loadRooms()
                        },
                        shouldShowCompletionOnAppear: true
                    )
                    
                case .roomEnter:
                    RoomEnterView(
                        onJoin: { roomId in
                            path.append(.joinedRoom(roomId: roomId))
                        }
                    )
                    
                case .joinedRoom(let roomId):
                    RoomView(
                        roomId: roomId,
                        onBack: {
                            path.removeAll()
                            loadRooms()
                        }
                    )
                }
            }
            .onAppear {
                loadRooms()
            }
        }
        .alert("ルーム一覧の取得に失敗しました", isPresented: $showErrorAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
    }
    
    private func loadRooms() {
        isLoadingRooms = true
        
        roomService.fetchMyRooms { result in
            DispatchQueue.main.async {
                isLoadingRooms = false
                
                switch result {
                case .success(let fetchedRooms):
                    rooms = fetchedRooms
                    
                case .failure(let error):
                    errorMessage = error.localizedDescription
                    showErrorAlert = true
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
