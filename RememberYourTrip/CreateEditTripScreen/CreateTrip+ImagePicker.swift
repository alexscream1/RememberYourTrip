//
//  CreateTripController+ImagePicker.swift
//  RememberYourTrip
//
//  Created by Alexey Onoprienko on 27.03.2021.
//

import UIKit

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension CreateTripController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            tripImageView.image = editedImage
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            tripImageView.image = originalImage
        }
        
        setupCircularImageStyle()
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
