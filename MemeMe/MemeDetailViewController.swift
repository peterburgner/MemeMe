//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Peter Burgner on 5/27/19.
//  Copyright © 2019 Peter Burgner. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    var meme = Meme()
    
    override func viewWillAppear(_ animated: Bool) {
        imageView.image = meme.memedImage
    }
}
