//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Ginny Pennekamp on 3/1/17.
//  Copyright © 2017 GhostBirdGames. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var fontSlider: UISlider!
    @IBOutlet weak var changeFontLabel: UILabel!
    
    // MARK: - Properties
    
    let memeTextFieldDelegate = MemeTextFieldDelegate()
    
    // MARK: - View Control
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // set up the style of textFields
        memeTextFieldDelegate.setUpTextField(topTextField, label: "TOP")
        memeTextFieldDelegate.setUpTextField(bottomTextField, label: "BOTTOM")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // subscribe to keyboard notifications
        subscribeToKeyboardNotifications()
        // disable camera if there is no camera on the device
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // show or hide the share button based on if there is a selected image or not
        if (self.imageView.image != nil) {
            shareButton.isEnabled = true
        } else {
            shareButton.isEnabled = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // unsubscribe to keyboard notifications
        unsubscribeToKeyboardNotifications()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        // sets the status bar to white against the app's black background
        return .lightContent
    }
    
    func showToolbars(_ show: Bool) {
        // hides the toolbars so meme can be captured
        toolbar.isHidden = show
        navigationBar.isHidden = show
        fontSlider.isHidden = show
        changeFontLabel.isHidden = show
    }
    
    // MARK: - Keyboard Notifications
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        // gets the size of the user's keyboard
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func keyboardWillShow(_ notification: Notification) {
        // shifts the view up the height of the keyboard (only on bottom text field)
        if bottomTextField.isFirstResponder {
            view.frame.origin.y -= getKeyboardHeight(notification)
        } else if topTextField.isFirstResponder {
            view.frame.origin.y = 0
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        // shifts the view down to the bottom when keyboard closes
        view.frame.origin.y = 0
    }
    
    func subscribeToKeyboardNotifications() {
        // subscribes to keyboard notifications
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications() {
        // unsubscribes to keyboard notifications
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    // MARK: - Image Picker Controller Delegate
    
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
            imageView.contentMode = .scaleAspectFit
            imageView.image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // dismiss UIImagePickerController on cancel
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Create and Save Meme Image
    
    func generateMemedImage() -> UIImage {
        // generates the memedImage
        
        // hide toolbar and navbar
        showToolbars(true)
        // render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        // show toolbar and navbar
        showToolbars(false)
        
        return memedImage
    }
    
    func save(memedImage: UIImage) {
        // saves the current user generated meme
        if let topText = topTextField.text, let bottomText = bottomTextField.text, let originalImage = imageView.image {
            let meme = Meme(topText: topText, bottomText: bottomText, originalImage: originalImage, memedImage: memedImage)
            savedMemes.append(meme)
        }
    }
    
    // MARK: - Choose Image
    
    @IBAction func chooseImageFromCameraRoll(_ sender: Any) {
        // allows user to choose an image from Camera Roll
        let pickerController = createImagePickerController(sourceType: .photoLibrary)
        self.present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func chooseImageFromCamera(_ sender: Any) {
        // allows user to take a photo for use
        let pickerController = createImagePickerController(sourceType: .camera)
        self.present(pickerController, animated: true, completion: nil)
    }
    
    // MARK: - Share Image
    
    @IBAction func share(_ sender: Any) {
        // shares a memed image
        
        let memedImage = generateMemedImage()
        // define an instance of the ActivityViewController, pass the AVC a memed image as an activity item
        let controller = UIActivityViewController(activityItems: [memedImage], applicationActivities: [])
        self.present(controller, animated: true, completion: nil)
        
        // save meme (UIActivityViewController completionWithItemsHandler)
        // handler reads (activity, success, items, error)
        controller.completionWithItemsHandler = { (_, success, _, _) in
            if success {
                self.save(memedImage: memedImage)
                // dismiss activity view
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - Cancel Image
    
    @IBAction func cancel(_ sender: Any) {
        // resets the meme to a blank canvas
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        imageView.image = nil
    }
    
    // MARK: - Change Meme Font
    
    func changeTextFieldFont(to fontName: String) {
        topTextField.font = UIFont(name: fontName, size: 40)!
        bottomTextField.font = UIFont(name: fontName, size: 40)!
    }

    @IBAction func changeFont(_ sender: Any) {
        // allows the user to change the meme's font
        switch fontSlider.value {
        case 0...1:
            changeTextFieldFont(to: "HelveticaNeue-CondensedBlack")
        case 1...2:
            changeTextFieldFont(to: "ChalkboardSE-Bold")
        case 2...3:
            changeTextFieldFont(to: "Impact")
        case 3...4:
            changeTextFieldFont(to: "STARWARS")
        case 4...4.75:
            changeTextFieldFont(to: "AmericanTypewriter")
        case 4.75...5:
            changeTextFieldFont(to: "Futura-CondensedMedium")
        default:
            changeTextFieldFont(to: "Impact")
        }
    }

}

