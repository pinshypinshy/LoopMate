//
//  RoomCellView.swift
//  LoopMate
//
//  Created by 平石悠生 on 2026/03/03.
//

import SwiftUI

struct RoomCellView: View {
    
    let room: Room
    @State var isMember: Bool = true
    var join: (() -> Void)? = nil
    
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(Color.gray.opacity(0.25))
                .frame(width: 44, height: 44)
            
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(room.name)
                        .font(.headline)
                        .foregroundStyle(.primary)
                    
                    if isMember {
                        Spacer()
                        
                        Text(room.code)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                
                HStack(spacing: 8) {
                    Text("メンバー")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    HStack(spacing: 2) {
                        ForEach(0..<min(room.memberCount, 3), id: \.self) { _ in
                            Image(systemName: "person.circle.fill")
                                .font(.system(size: 14))
                                .foregroundStyle(.secondary)
                        }
                        if room.memberCount > 3 {
                            Text("+\(room.memberCount - 3)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .padding(.leading, 2)
                        }
                    }
                }
                if isMember {
                    Text(room.progressText)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            
            if !isMember {
                Spacer()
                
                Button {
                    join?()
                } label: {
                    Text("参加")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(
                            Capsule()
                                .fill(Color.orange)
                        )
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color.white)
        )
    }
}

#Preview {
    RoomCellView(room: Room.preview)
}
