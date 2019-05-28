//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Peter Burgner on 5/27/19.
//  Copyright © 2019 Peter Burgner. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UICollectionViewController {
    
    // MARK: Properties
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    // MARK: View Functions
    override func viewDidLoad() {
        let space:CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        flowLayout.minimumLineSpacing = space
        flowLayout.minimumInteritemSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    
    
    // MARK: Collection Functions
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let memes = appDelegate.memes
        let controller = storyboard?.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        controller.meme = memes[indexPath.row]
        navigationController!.pushViewController(controller, animated: true)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let memes = appDelegate.memes
        return memes.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let memes = appDelegate.memes
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath) as! MemeCollectionViewCell
        
        item.imageView.image = memes[indexPath.row].memedImage
        
        return item
    }
    
}
