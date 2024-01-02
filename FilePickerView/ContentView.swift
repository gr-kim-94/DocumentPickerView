//
//  ContentView.swift
//  FilePickerView
//
//  Created by 김가람 on 2024/01/02.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel: ContentViewModel = ContentViewModel()
    
    @State private var isShowingDialog: Bool = false
    @State private var isDocumentPresented: Bool = false
    @State private var isCameraPresented: Bool = false
    @State private var isPhotoPresented: Bool = false
    
    var body: some View {
        ZStack {
            Button {
                isShowingDialog = true
            } label: {
                Image("square.and.arrow.up")
                    .frame(width: 44, height: 44)
            }
        }
        .fullScreenCover(isPresented: $isDocumentPresented) {
            DocumentPickerView(isPresented: $isDocumentPresented, data: $viewModel.selectedFileData)
        }
        .fullScreenCover(isPresented: $isCameraPresented) {
            CameraPickerView(isPresented: $isCameraPresented, data: $viewModel.selectedFileData)
        }
        .fullScreenCover(isPresented: $isPhotoPresented) {
            PhotoPickerView(isPresented: $isPhotoPresented, data: $viewModel.selectedFileData)
        }
        .confirmationDialog("Selected File", isPresented: $isShowingDialog, actions: {
            Button("Document") {
                isShowingDialog = false
                isDocumentPresented = true
            }
            Button("Camera") {
                isShowingDialog = false
                viewModel.requestCameraPermissions { allowed in
                    if allowed {
                        isCameraPresented = true
                    }
                }
            }
            Button("Photo") {
                isShowingDialog = false
                viewModel.requestPhotoPermissions { allowed in
                    if allowed {
                        isPhotoPresented = true
                    }
                }
            }
        })
    }
}

#Preview {
    ContentView()
}
