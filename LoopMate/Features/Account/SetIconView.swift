import SwiftUI

struct SetIconView: View {
    
    @Binding var username: String
    @Binding var displayName: String
    @Binding var selectedIconName: String
    
    let onCompleted: () -> Void
    
    let iconCandidates = [
        "person.crop.circle.fill",
        "person.circle.fill",
        "face.smiling.fill",
        "star.circle.fill",
        "heart.circle.fill",
        "moon.circle.fill"
    ]
    
    var body: some View {
        VStack(spacing: 24) {
            Text("アイコンを設定")
                .font(.title2)
                .bold()
            
            Image(systemName: selectedIconName)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .padding()
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 20) {
                ForEach(iconCandidates, id: \.self) { icon in
                    Button {
                        selectedIconName = icon
                    } label: {
                        Image(systemName: icon)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(
                                selectedIconName == icon
                                ? Color.orange.opacity(0.2)
                                : Color.gray.opacity(0.1)
                            )
                            .cornerRadius(12)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .padding(.top, 40)
        .navigationTitle("アカウント登録")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    registerAccount()
                    onCompleted()
                } label: {
                    Image(systemName: "checkmark")
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.circle)
                .tint(.orange)
            }
        }
    }
    
    func registerAccount() {
        print("username: \(username)")
        print("displayName: \(displayName)")
        print("icon: \(selectedIconName)")
    }
}

#Preview {
    NavigationStack {
        SetIconView(
            username: .constant(""),
            displayName: .constant(""),
            selectedIconName: .constant("person.crop.circle.fill"),
            onCompleted: {}
        )
    }
}
