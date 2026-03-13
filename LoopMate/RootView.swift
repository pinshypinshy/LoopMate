//
//  RootView.swift
//  LoopMate
//
//  Created by 平石悠生 on 2026/03/13.
//

import SwiftUI

struct RootView: View {
    @State private var isRegistered = false
    @State private var isRegistrationPresented: Bool

    init() {
        let registered = false
        _isRegistered = State(initialValue: registered)
        _isRegistrationPresented = State(initialValue: !registered)
    }

    var body: some View {
        ContentView()
            .fullScreenCover(isPresented: $isRegistrationPresented) {
                AccountRegistrationFlowView(
                    onCompleted: {
                        isRegistered = true
                        isRegistrationPresented = false
                    }
                )
            }
    }
}

#Preview {
    RootView()
}
