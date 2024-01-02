//
//  PhotoPickerView.swift
//  FilePickerView
//
//  Created by 김가람 on 2024/01/02.
//

import SwiftUI
import PhotosUI
import CoreServices

struct PhotoPickerView: UIViewControllerRepresentable {
    
    @Binding var isPresented: Bool
    @Binding var data: Data?
    
    var selectionLimit: Int = 1
    var filter: PHPickerFilter = .images
    
    private var fetchResult: PHFetchResult<PHAsset>?
    
    // MARK: - Init
    init(isPresented: Binding<Bool>, selectionLimit: Int = 1, filter: PHPickerFilter = .images, data: Binding<Data?> = .constant(nil)) {
        _isPresented = isPresented
        self.selectionLimit = selectionLimit
        self.filter = filter
        _data = data
        
        let fetchOption = PHFetchOptions()
        self.fetchResult = PHAsset.fetchAssets(with: fetchOption)
    }
    
    // MARK: - Make UI View
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.selectionLimit = selectionLimit
        configuration.filter = filter
        
        let vc = PHPickerViewController(configuration: configuration)
        vc.delegate = context.coordinator
        
        return vc
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    class Coordinator: PHPickerViewControllerDelegate {
        
        var parent: PhotoPickerView
        
        // MARK: - Init
        init(parent: PhotoPickerView) {
            self.parent = parent
        }
        
        // MARK: - Load Image
        private func loadImages(asset: PHAsset) {
            let requestOption = PHContentEditingInputRequestOptions()
            requestOption.isNetworkAccessAllowed = true
            asset.requestContentEditingInput(with: requestOption) { editingInput, info in
                let imageRequestOption = PHImageRequestOptions()
                imageRequestOption.isSynchronous = false
                imageRequestOption.isNetworkAccessAllowed = true
                
                if let path = editingInput?.fullSizeImageURL {
                    PHImageManager.default().requestImageDataAndOrientation(for: asset, options: imageRequestOption) { imageData, dataUTI, orientation, imageInfo in
                        let name = path.deletingPathExtension().lastPathComponent
                        let fileExtension = path.pathExtension.lowercased()
                        debugPrint("** selected image : \(name).\(fileExtension)")
                        
                        self.parent.data = imageData
                        self.parent.isPresented = false
                    }
                } else {
                    self.parent.isPresented = false
                }
            }
        }
        
        // MARK: - PHPicker Delegate
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            debugPrint("** PHPickerResult : \(results)")
            let assetIdentifiers = results.compactMap(\.assetIdentifier)
            debugPrint("assetIdentifiers : \(assetIdentifiers)")
            if let asset = PHAsset.fetchAssets(withLocalIdentifiers: assetIdentifiers, options: nil).firstObject {
                loadImages(asset: asset)
            } else {
                parent.isPresented = false
            }
        }
    }
}
