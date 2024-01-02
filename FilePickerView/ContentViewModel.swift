//
//  ContentViewModel.swift
//  FilePickerView
//
//  Created by 김가람 on 2024/01/02.
//

import Foundation
import Combine
import Photos

class ContentViewModel: ObservableObject {
    private var cancelBag = Set<AnyCancellable>()
    
    @Published var selectedFileData: Data?
    
    init() {
        $selectedFileData
            .sink(receiveValue: { newValue in
                if let data = newValue {
                    // Handler File Data
                    debugPrint(data)
                }
            })
            .store(in: &cancelBag)
    }
}

extension ContentViewModel {
    // MARK: - Request Permission
    func requestPhotoPermissions(_ block: @escaping (_ allowed: Bool) -> Void) {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        
        switch status {
        case .authorized, .limited:
            block(true)
            
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { authorizationStatus in
                DispatchQueue.main.async {
                    if authorizationStatus == .authorized || authorizationStatus == .limited {
                        block(true)
                    } else {
                        block(false)
                    }
                }
            }
            
        default:
            block(false)
            break
        }
    }
    
    func requestCameraPermissions(_ block: @escaping (_ allowed: Bool) -> Void) {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch status {
        case .authorized:
            block(true)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    block(granted)
                }
            }
        default:
            block(false)
        }
    }
}
