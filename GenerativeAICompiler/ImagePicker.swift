//
//  ImagePicker.swift


//

import UIKit
import SwiftUI
import CoreML
import Vision


struct ImagePicker: UIViewControllerRepresentable {
   
    @Environment(\.presentationMode) private var presentationMode
    @Binding var selectedImage: UIImage

    

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {

        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = context.coordinator

        return imagePicker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {

    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

        var parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            DispatchQueue.main.async {
                if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                    self.parent.selectedImage = image
                }
                self.parent.presentationMode.wrappedValue.dismiss()
                
            }
        }

    }
}
//
