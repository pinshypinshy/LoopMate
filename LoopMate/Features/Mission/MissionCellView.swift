//
//  MissionCellView.swift
//  LoopMate
//
//  Created by 平石悠生 on 2026/03/03.
//

import SwiftUI

struct MissionCellView: View {
    
    let mission: TodayAllRoomsMissionData
    
    var body: some View {
        HStack {
            Circle()
                .fill(Color.gray.opacity(0.25))
                .frame(width: 44, height: 44)
            
            Text(mission.roomName)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundStyle(.gray)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color.white)
        )
    }
}

#Preview {
    MissionCellView(mission: TodayAllRoomsMissionData.preview)
}
