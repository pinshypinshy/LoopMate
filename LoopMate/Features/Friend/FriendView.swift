//
//  FriendView.swift
//  LoopMate
//
//  Created by 平石悠生 on 2026/03/03.
//

import SwiftUI

struct FriendView: View {
    
    @State private var searchText = ""
    let users: [User] = [
        User(id: "user_001", name: "ユーザー1"),
        User(id: "user_002", name: "ユーザー2"),
        User(id: "user_003", name: "ユーザー3")
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.orange).opacity(0.1).ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("現在のフレンド")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                        VStack(spacing: 20) {
                            ForEach(users) { user in
                                FriendCellView(user: user)
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
            .navigationTitle("フレンド")
            .navigationBarTitleDisplayMode(.inline)
            
            .searchable(text: $searchText,
                                    placement: .navigationBarDrawer(displayMode: .always),
                                    prompt: "フレンドを検索")
            
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
    FriendView()
}
