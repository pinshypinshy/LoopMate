//
//  RoomCreateCompleteView.swift
//  LoopMate
//
//  Created by 平石悠生 on 2026/03/11.
//

import SwiftUI

struct RoomCreateCompleteView: View {
    
    let onClose: () -> Void
    
    var body: some View {
        ZStack {
            Color.orange.ignoresSafeArea()
            
            VStack(spacing: 16) {
                
                Spacer()
                
                Text("ルームを作成しました。")
                    .font(.title)
                    .bold()
                    .foregroundStyle(.white)
                    .padding(.bottom, 40)
                
                VStack(alignment: .leading, spacing: 12) {
                    HStack(spacing: 12) {
                        Circle()
                            .fill(Color.gray.opacity(0.25))
                            .frame(width: 32, height: 32)
                        Text("ルーム1")
                            .font(.title2)
                            .bold()
                            .foregroundStyle(.white)
                    }
                    .padding(.horizontal)
                    
                    Divider()
                    
                    HStack() {
                        Text("ルームコード：5N3D6")
                            .font(.title3)
                            .bold()
                            .foregroundStyle(.white)
                        
                        Spacer()
                        
                        Button {
                            
                        } label: {
                            Image(systemName: "square.on.square")
                                .foregroundStyle(.white)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(20)
                .background(Color.gray.opacity(0.25))
                .cornerRadius(16)
                
                Spacer()
                
                Button {
                    
                } label: {
                    Text("フレンドを招待")
                        .font(.title3)
                        .bold()
                        .foregroundStyle(.orange)
                }
                .buttonStyle(.plain)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.white)
                .cornerRadius(16)
                
                Button {
                    onClose()
                } label: {
                    Text("閉じる")
                        .font(.title3)
                        .bold()
                        .foregroundStyle(.white)
                }
                .buttonStyle(.plain)
                .frame(maxWidth: .infinity)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white, lineWidth: 2)
                )
                .padding(.bottom, 40)
            }
            .padding(.horizontal, 24)
        }
    }
}

#Preview {
    RoomCreateCompleteView(onClose: {})
}
