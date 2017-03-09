//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Ginny Pennekamp on 3/6/17.
//  Copyright © 2017 GhostBirdGames. All rights reserved.
//

import UIKit

class MemeTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIViewControllerTransitioningDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    
    let appDelegate = (UIApplication.shared.delegate) as! AppDelegate
    let customPresentAnimationController = CustomPresentAnimationController()
    let memeTextFieldDelegate = MemeTextFieldDelegate()

    // MARK: - View
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // reload the table data
        self.tableView.reloadData()
    }
    
    // MARK: - Table View Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // returns the count of memes in appDelegate
        return appDelegate.memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // populates a row for each meme in appDelegate.memes
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableViewCell")! as! MemeTableViewCell
        // selects the current meme from the database
        let meme = appDelegate.memes[(indexPath as NSIndexPath).row]
        // populates the table row with meme data
        if let topText = meme.topText, let bottomText = meme.bottomText {
            cell.topTextLabel?.attributedText = memeTextFieldDelegate.setLabelFont(text: topText, meme: meme, fontSize: 15.0)
            cell.bottomTextLabel?.attributedText = memeTextFieldDelegate.setLabelFont(text: bottomText, meme: meme, fontSize: 15.0)
            cell.memeTextLabel?.text = "\(topText) \(bottomText)"
        }
        cell.memeImageView?.image = meme.originalImage
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // transitions to the editor controller with current memes details
        let editorController = self.storyboard!.instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
        // pass in info about current meme
        let meme = appDelegate.memes[(indexPath as NSIndexPath).row]
        if let topText = meme.topText, let bottomText = meme.bottomText {
            editorController.topText = topText
            editorController.bottomText = bottomText
            editorController.image = meme.originalImage
        }
        navigationController!.pushViewController(editorController, animated: true)
    }
    
    // MARK: - Editing
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // allows deletion of rows
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        // deletes selected row
        if editingStyle == .delete {
            appDelegate.memes.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
    
    @IBAction func editTable(_ sender: UIBarButtonItem) {
        // allows table rows to be deleted
        tableView.setEditing(!tableView.isEditing, animated: true)
        // changes the text of the edit button
        if tableView.isEditing {
            sender.title = "Done"
        } else {
            sender.title = "Edit"
        }
    }
    
    // MARK: - Animation
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        // applies animation styles
        return customPresentAnimationController
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // applies custom slide from bottom animation to transition
        if segue.identifier == "showEditorFromTableView" {
            let toViewController = segue.destination as! MemeEditorViewController
            toViewController.transitioningDelegate = self
        }
    }

}
