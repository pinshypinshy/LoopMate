//
//  MissionCompletionView.swift
//  LoopMate
//
//  Created by 平石悠生 on 2026/03/12.
//

import SwiftUI
import PhotosUI
import UIKit

struct MissionCompletionView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @State var value: String = ""
    @State var comment: String = ""
    
    @State private var showPhotoSourceDialog = false
    @State private var showCameraPicker = false
    @State private var showPhotoLibraryPicker = false
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.orange).opacity(0.1).ignoresSafeArea()
                ScrollView {
                    VStack {
                        Button {
                            showPhotoSourceDialog = true
                        } label: {
                            VStack {
                                HStack {
                                    Text("写真を追加")
                                        .foregroundStyle(.orange)
                                    
                                    Spacer()
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                
                                if let selectedImage {
                                    Divider()
                                    
                                    Image(uiImage: selectedImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(maxWidth: .infinity)
                                        .clipped()
                                        .cornerRadius(8)
                                        .padding()
                                }
                            }
                            .background(Color.white)
                            .cornerRadius(12)
                            
                        }
                        .buttonStyle(.plain)
                        .padding(.horizontal)
                        .padding(.top)
                        .confirmationDialog(
                            "写真を追加",
                            isPresented: $showPhotoSourceDialog,
                            titleVisibility: .visible
                        ) {
                            Button("撮影") {
                                showCameraPicker = true
                            }
                            
                            Button("アルバム") {
                                showPhotoLibraryPicker = true
                            }
                            
                            Button("キャンセル", role: .cancel) { }
                        }
                        
                        TextField("数値を入力", text: $value)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .padding(.horizontal)
                            .padding(.top)
                        
                        VStack {
                            ZStack(alignment: .topLeading) {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.white)
                                    .frame(height: 140)
                                
                                if comment.isEmpty {
                                    Text("コメントを入力")
                                        .foregroundStyle(.tertiary)
                                        .padding(.top, 14)
                                        .padding(.leading, 14)
                                }
                                
                                TextEditor(text: $comment)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 8)
                                    .frame(height: 140)
                                    .scrollContentBackground(.hidden)
                                    .background(Color.clear)
                            }
                            .padding()
                        }
                        
                        Button {
                            // あとで画面遷移の処理を書く
                        } label: {
                            HStack {
                                Spacer()
                                
                                Text("削除")
                                    .foregroundStyle(.red)
                                
                                Spacer()
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .cornerRadius(12)
                        }
                        .buttonStyle(.plain)
                        .padding(.horizontal)
                        .padding(.top)
                    }
                }
            }
            .navigationTitle("ミッション名")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Text("登録")
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.orange)
                }
            }
            .photosPicker(
                isPresented: $showPhotoLibraryPicker,
                selection: $selectedPhotoItem,
                matching: .images
            )
            .task(id: selectedPhotoItem) {
                guard let selectedPhotoItem else { return }
                
                if let data = try? await selectedPhotoItem.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    selectedImage = uiImage
                }
            }
            .sheet(isPresented: $showCameraPicker) {
                ImagePicker(selectedImage: $selectedImage, sourceType: .camera)
            }
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    let sourceType: UIImagePickerController.SourceType
    
    func makeCoordinator() -> Coordinator {
        Coordinator(selectedImage: $selectedImage)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
    }
    
    final class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        @Binding var selectedImage: UIImage?
        
        init(selectedImage: Binding<UIImage?>) {
            _selectedImage = selectedImage
        }
        
        func imagePickerController(
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
        ) {
            if let image = info[.originalImage] as? UIImage {
                selectedImage = image
            }
            picker.dismiss(animated: true)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}

#Preview {
    MissionCompletionView()
}
