//
//  CameraPickerView.swift
//  FilePickerView
//
//  Created by 김가람 on 2024/01/02.
//

import SwiftUI
import AVFoundation
import CoreServices

struct CameraPickerView: UIViewControllerRepresentable {
    
    @Binding var isPresented: Bool
    @Binding var data: Data?
    
    var sourceType: UIImagePickerController.SourceType = .camera
    var allowsEditing: Bool = false
    var cameraDevice: UIImagePickerController.CameraDevice = .rear
    var cameraCaptureMode: UIImagePickerController.CameraCaptureMode = .photo
    
    // MARK: - Make UI View
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let vc = UIImagePickerController()
        vc.sourceType = sourceType
        vc.allowsEditing = allowsEditing
        vc.cameraDevice = cameraDevice
        vc.cameraCaptureMode = cameraCaptureMode
        vc.delegate = context.coordinator
        
        return vc
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        var parent: CameraPickerView
        
        // MARK: Init
        init(parent: CameraPickerView) {
            self.parent = parent
        }
        
        private func loadImage(_ image: UIImage) {
            var imageData: Data? = nil
            
            if let pngData = image.pngData() {
                // PNG는 비손실 그래픽 파일 포맷으로 용량이 너무 큼.
                imageData = pngData
            } else if let jpegData = image.jpegData(compressionQuality: 1) {
                imageData = jpegData
            }
            
            parent.data = imageData
            parent.isPresented = false
        }
        
        // MARK: Delegate
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            debugPrint(String(describing: info[UIImagePickerController.InfoKey.mediaMetadata]))
            
            if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                loadImage(editedImage)
            } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                loadImage(originalImage)
            } else {
                parent.isPresented = false
            }
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.isPresented = false
        }
    }
}
