//
//  RoomCreationFlowHostView.swift
//  LoopMate
//
//  Created by 平石悠生 on 2026/03/12.
//

import SwiftUI

private enum RoomCreationRoute: Hashable {
    case room
}

struct RoomCreationFlowHostView: View {
    let onCreateCompleted: () -> Void

    var body: some View {
        RoomCreateView(
            onCreate: {
                onCreateCompleted()
            }
        )
    }
}

#Preview {
    NavigationStack {
        RoomCreationFlowHostView(onCreateCompleted: {})
    }
}
