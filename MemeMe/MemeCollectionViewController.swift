//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Ginny Pennekamp on 3/6/17.
//  Copyright © 2017 GhostBirdGames. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIViewControllerTransitioningDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Properties
    
    let appDelegate = (UIApplication.shared.delegate) as! AppDelegate
    let customPresentAnimationController = CustomPresentAnimationController()
    let memeTextFieldDelegate = MemeTextFieldDelegate()
    
    // MARK: - View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // set up custom flow
        fitCollectionFlowToSize(self.view.frame.size)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // reload the table data
        self.collectionView.reloadData()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        // set up custom flow
        if flowLayout != nil {
            fitCollectionFlowToSize(size)
        }
    }
    
    func fitCollectionFlowToSize(_ size: CGSize) {
        // determine the number of and spacing between collection items
        let space: CGFloat = 3.0
        // adjust dimension to width and height of screen
        let dimension = size.width >= size.height ? (size.width - (5*space))/5.0 : (size.width - (2*space))/3.0
        // set up custom flow
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    // MARK: - Collection View
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // returns the number of items in meme array
        return  appDelegate.memes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // populates the collection view cell with data from meme array
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath) as! MemeCollectionViewCell
        // pass in info about current meme
        let meme = appDelegate.memes[(indexPath as NSIndexPath).row]
        if let topText = meme.topText, let bottomText = meme.bottomText {
            cell.topTextLabel?.attributedText = memeTextFieldDelegate.setLabelFont(text: topText, meme: meme, fontSize: 20.0)
            cell.bottomTextLabel?.attributedText = memeTextFieldDelegate.setLabelFont(text: bottomText, meme: meme, fontSize: 20.0)
        }
        cell.imageView?.image = meme.originalImage
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // transitions to the detail controller with current memes details
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        // pass in info about current meme
        let meme = appDelegate.memes[(indexPath as NSIndexPath).row]
        detailController.meme = meme
        navigationController!.pushViewController(detailController, animated: true)
    }
    
    // MARK: - Animation
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return customPresentAnimationController
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // animate segue to MemeEditorViewController
        if segue.identifier == "showEditorFromCollectionView" {
            let toViewController = segue.destination as! MemeEditorViewController
            toViewController.transitioningDelegate = self
        }
    }

}
