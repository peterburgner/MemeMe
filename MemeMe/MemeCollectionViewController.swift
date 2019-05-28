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
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    // MARK: Collection Functions
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: Add detail view
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
