//
//  DocumentPickerView.swift
//  FilePickerView
//
//  Created by 김가람 on 2024/01/02.
//

import SwiftUI
import UniformTypeIdentifiers

struct DocumentPickerView: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    @Binding var data: Data?
    
    var allowsMultipleSelection: Bool = false
    var shouldShowFileExtensions: Bool = true
    
    // MARK: - Make UI View
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        var types = [UTType]()
        
        if let publicType = UTType("public.item") {
            types.append(publicType)
        }
        let vc = UIDocumentPickerViewController(forOpeningContentTypes: types)
        
        vc.allowsMultipleSelection = allowsMultipleSelection
        vc.shouldShowFileExtensions = shouldShowFileExtensions
        vc.delegate = context.coordinator
        
        return vc
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var parent: DocumentPickerView
        
        // MARK: Init
        init(parent: DocumentPickerView) {
            self.parent = parent
        }
        
        private func loadFile(_ url: URL) {
            // Start accessing a security-scoped resource.
            guard url.startAccessingSecurityScopedResource() else {
                // Handle the failure here.
                return
            }
            
            // Make sure you release the security-scoped resource when you finish.
            defer { url.stopAccessingSecurityScopedResource() }
            
            if FileManager.default.fileExists(atPath: url.path),
               FileManager.default.isReadableFile(atPath: url.path) {
                let data = FileManager.default.contents(atPath: url.path)
                parent.data = data
            } else {
                parent.data = nil
            }
            
            url.stopAccessingSecurityScopedResource()
            
            parent.isPresented = false
        }
        
        // MARK: Delegate
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let url = urls.first else {
                parent.isPresented = false
                
                return
            }
            
            loadFile(url)
        }
        
        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            parent.isPresented = false
        }
    }
}
