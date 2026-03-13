//
//  ProfileView.swift
//  LoopMate
//
//  Created by 平石悠生 on 2026/03/03.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct ProfileView: View {
    
    @State private var username: String = ""
    @State private var displayName: String = ""
    @State private var iconName: String = "person.crop.circle.fill"
    
    let user = User(id: "user_000", name: "テストユーザー")
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.orange).opacity(0.1).ignoresSafeArea()
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: iconName)
                                .font(.system(size: 92))
                                .foregroundStyle(.black.opacity(0.5))
                                .background(
                                    Circle()
                                        .fill(.gray.opacity(0.4))
                                )
                            VStack(alignment: .leading, spacing: 4) {
                                Text(displayName.isEmpty ? "表示名未設定" : displayName)
                                    .font(.title2)
                                    .bold()
                                    .padding(.top, 4)
                                Text(username.isEmpty ? "@unknown" : "@\(username)")
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
                        
                        NavigationLink {
                            ProfileEditView(
                                username: $username,
                                displayName: $displayName,
                                iconName: $iconName
                            )
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
        .onAppear {
            fetchProfile()
        }
    }
    
    private func fetchProfile() {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("uidが取得できなかった")
            return
        }
        
        let db = Firestore.firestore()
        
        db.collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                print("プロフィール取得失敗: \(error)")
                return
            }
            
            guard let data = snapshot?.data() else {
                print("プロフィールデータが存在しない")
                return
            }
            
            username = data["username"] as? String ?? ""
            displayName = data["displayName"] as? String ?? ""
            iconName = data["iconName"] as? String ?? "person.crop.circle.fill"
            
            print("プロフィール取得成功")
        }
    }
}

#Preview {
    ProfileView()
}
