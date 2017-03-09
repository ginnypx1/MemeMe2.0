//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Ginny Pennekamp on 3/9/17.
//  Copyright © 2017 GhostBirdGames. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topTextLabel: UILabel!
    @IBOutlet weak var bottomTextLabel: UILabel!

    // MARK: - Properties
    
    let memeTextFieldDelegate = MemeTextFieldDelegate()
    var meme: Meme?
    
    // MARK: - Display
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Load the meme
        if let meme = meme, let topText = meme.topText, let bottomText = meme.bottomText {
            topTextLabel?.attributedText = memeTextFieldDelegate.setLabelFont(text: topText, meme: meme, fontSize: 40.0)
            bottomTextLabel?.attributedText = memeTextFieldDelegate.setLabelFont(text: bottomText, meme: meme, fontSize: 40.0)
            imageView.image = meme.originalImage
        }
        
        // Load edit button
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(MemeDetailViewController.openEditor))
        self.navigationItem.rightBarButtonItem = editButton
    }
    
    
    // MARK: - Segue to Editor View
    
    func openEditor() {
        // transitions to the editor controller with current memes details
        let editorController = self.storyboard!.instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
        // pass in info about current meme
        if let meme = meme, let topText = meme.topText, let bottomText = meme.bottomText {
            editorController.topText = topText
            editorController.bottomText = bottomText
            editorController.image = meme.originalImage
            editorController.selectedFont = meme.fontName
        }
        present(editorController, animated: true)
    }

}
