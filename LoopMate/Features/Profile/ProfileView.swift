//
//  ProfileView.swift
//  LoopMate
//
//  Created by 平石悠生 on 2026/03/03.
//

import SwiftUI

struct ProfileView: View {
    let user = User(id: "user_000", name: "テストユーザー")
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.orange).opacity(0.1).ignoresSafeArea()
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "person.crop.circle")
                                .font(.system(size: 92))
                                .foregroundStyle(.black.opacity(0.5))
                                .background(
                                    Circle()
                                        .fill(.gray.opacity(0.4))
                                )
                            VStack(alignment: .leading, spacing: 4) {
                                Text(user.name)
                                    .font(.title2)
                                    .bold()
                                    .padding(.top, 4)
                                Text("@\(user.id)")
                                    .font(.headline)
                                Button {
                                    
                                } label: {
                                    HStack(spacing: 4) {
                                        Text("\(user.friends.count)")
                                            .font(.footnote)
                                            .bold()
                                        Text("フレンド")
                                            .font(.footnote)
                                    }
                                    
                                    
                                }
                                .buttonStyle(.plain)
                                .padding(.top, 12)
                            }
                            Spacer()
                            
                        }
                        .padding(.horizontal)
                        
                        Button {
                            
                        } label: {
                            Text("プロフィールを編集")
                                .font(.subheadline)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 6)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.gray.opacity(0.2))
                                )
                        }
                        .buttonStyle(.plain)
                        .padding(.horizontal)
                        
                    }
                }
            }
            .navigationTitle("プロフィール")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button {
                        
                    } label: {
                        Image(systemName: "gearshape")
                    }
                }
            }
        }
        
        
        
    }
}

#Preview {
    ProfileView()
}
