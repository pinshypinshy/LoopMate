//
//  FriendCellView.swift
//  LoopMate
//
//  Created by 平石悠生 on 2026/03/05.
//

import SwiftUI

struct FriendCellView: View {
    
    let user: User
    
    var body: some View {
        HStack {
            Circle()
                .fill(Color.gray.opacity(0.25))
                .frame(width: 44, height: 44)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(user.name)
                    .font(.headline)
                Text(user.id)
                    .font(.subheadline)
            }
            
            Spacer()
        }
    }
}

#Preview {
    FriendCellView(user: User.preview)
}
