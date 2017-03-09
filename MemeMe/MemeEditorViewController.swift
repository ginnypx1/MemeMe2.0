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
    
    var topText: String = "TOP"
    var bottomText: String = "BOTTOM"
    var image: UIImage?
    var selectedFont: String = "Impact"
    
    // MARK: - View Control
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // set up the style of textFields
        memeTextFieldDelegate.setUpTextField(topTextField, label: topText)
        memeTextFieldDelegate.setUpTextField(bottomTextField, label: bottomText)
        // add image if there is one
        if self.image != nil {
            imageView.image = image
        }
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
            // create a meme object
            let meme = Meme(topText: topText, bottomText: bottomText, fontName: selectedFont, originalImage: originalImage, memedImage: memedImage)
            // save to saved array of memes
            let appDelegate = (UIApplication.shared.delegate) as! AppDelegate
            appDelegate.memes.append(meme)
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
    
    // MARK: - Change Meme Font
    
    func changeTextFieldFont(to fontName: String) {
        topTextField.font = UIFont(name: fontName, size: 40)!
        bottomTextField.font = UIFont(name: fontName, size: 40)!
        selectedFont = fontName
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
    
    // MARK: - Cancel

    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}

