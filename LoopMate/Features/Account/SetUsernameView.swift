import SwiftUI

struct SetUsernameView: View {
    
    @FocusState private var isFocused: Bool
    
    @Binding var username: String
    @Binding var displayName: String
    @Binding var selectedIconName: String
    
    let onCompleted: () -> Void
    
    var body: some View {
        ZStack {
            Color.orange.opacity(0.1).ignoresSafeArea()
            
            VStack(spacing: 40) {
                Text("ユーザー名を設定してください。")
                    .font(.title2)
                    .bold()
                
                TextField("ユーザー名を入力", text: $username)
                    .focused($isFocused)
                    .onAppear {
                        isFocused = true
                    }
                    .multilineTextAlignment(.center)
                    .font(.title)
                    .padding(.horizontal)
                
                Spacer()
            }
            .padding(.top, 40)
        }
        .navigationTitle("アカウント登録")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    SetDisplayNameView(
                        username: $username,
                        displayName: $displayName,
                        selectedIconName: $selectedIconName,
                        onCompleted: onCompleted
                    )
                } label: {
                    Image(systemName: "checkmark")
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.circle)
                .tint(.orange)
                .disabled(username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
    }
}

#Preview {
    NavigationStack {
        SetUsernameView(
            username: .constant(""),
            displayName: .constant(""),
            selectedIconName: .constant("person.crop.circle.fill"),
            onCompleted: {}
        )
    }
}
