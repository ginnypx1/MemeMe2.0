//
//  MemeEditorImagePickerDelegateExtension.swift
//  MemeMe
//
//  Created by Ginny Pennekamp on 3/6/17.
//  Copyright © 2017 GhostBirdGames. All rights reserved.
//

import Foundation
import UIKit

extension MemeEditorViewController {
    
    func createImagePickerController(sourceType: UIImagePickerControllerSourceType) -> UIImagePickerController {
        // creates and sets properties of a UIImagePickerController
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = sourceType
        pickerController.allowsEditing = false
        return pickerController
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // selects an image for the imageView
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.image = pickedImage
            imageView.contentMode = .scaleAspectFit
            imageView.image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // dismiss UIImagePickerController on cancel
        dismiss(animated: true, completion: nil)
    }
    
}
