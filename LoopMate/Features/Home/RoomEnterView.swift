//
//  RoomEnterView.swift
//  LoopMate
//
//  Created by 平石悠生 on 2026/03/12.
//

import SwiftUI

struct RoomEnterView: View {
    
    let onJoin: () -> Void
    
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""
    
    var body: some View {
        ZStack {
            Color(.orange).opacity(0.1).ignoresSafeArea()
            ScrollView {
                VStack() {
                    RoomCellView(room: Room.preview, isMember: false, join: {
                        
                        onJoin()
                    }
                    )
                }
                .padding(.top)
            }
            .padding(.horizontal)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                }
            }
        }
        .searchable(text: $searchText,
                    placement: .navigationBarDrawer(displayMode: .always),
                    prompt: "ルームコードを検索")
    }
}

#Preview {
    NavigationStack {
        RoomEnterView(onJoin: {})
    }
}
