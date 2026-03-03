//
//  MissionView.swift
//  LoopMate
//
//  Created by 平石悠生 on 2026/03/03.
//

import SwiftUI

struct MissionView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.orange).opacity(0.1).ignoresSafeArea()
            }
            .navigationTitle("ミッション")
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
    MissionView()
}
