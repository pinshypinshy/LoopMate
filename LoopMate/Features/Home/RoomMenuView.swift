//
//  RoomMenuView.swift
//  LoopMate
//
//  Created by 平石悠生 on 2026/03/15.
//

import SwiftUI

struct RoomMenuView: View {
    
    let room: Room
    var onLeaveCompleted: (() -> Void)? = nil
    
    @Environment(\.dismiss) private var dismiss
    @State private var isLeaveAlertPresented = false
    
    private let roomService = RoomService()
    
    var body: some View {
        ZStack {
            Color.orange.opacity(0.1).ignoresSafeArea()
            
            ScrollView {
                VStack {
                    Button {
                        isLeaveAlertPresented = true
                    } label : {
                        Text("ルームを退会")
                            .foregroundStyle(.red)
                            .frame(maxWidth: .infinity)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                }
                .padding()
                .alert("ルームを退会しますか？", isPresented: $isLeaveAlertPresented) {
                    Button("キャンセル", role: .cancel) {
                    }
                    
                    Button("退会する", role: .destructive) {
                        roomService.leaveRoom(room: room) { result in
                            switch result {
                            case .success:
                                dismiss()
                                onLeaveCompleted?()
                            case .failure(let error):
                                print(error)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("メニュー")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        RoomMenuView(room: .preview, onLeaveCompleted: {})
    }
}
