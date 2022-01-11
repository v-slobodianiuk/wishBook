//
//  ImagePicker.swift
//  WishBook
//
//  Created by Vadym Slobodianiuk on 15.08.2021.
//

import UIKit
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var imageData: Data?
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePickerVC: UIImagePickerController = UIImagePickerController()
        imagePickerVC.delegate = context.coordinator
        return imagePickerVC
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                let ratio = uiImage.size.height /  uiImage.size.width
                let sideDimension: CGFloat = 1000
                let resizedImage = uiImage.downsample(to: CGSize(width: sideDimension, height: sideDimension / ratio), scale: nil)
                // Convert the image into JPEG and compress the quality to reduce its size
                parent.imageData = resizedImage.jpegData(compressionQuality: 0.75)
            }
            
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
