//
//  FriendView.swift
//  LoopMate
//
//  Created by 平石悠生 on 2026/03/03.
//

import SwiftUI

struct FriendView: View {
    
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.orange).opacity(0.1).ignoresSafeArea()
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
