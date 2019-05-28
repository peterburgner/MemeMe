//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Peter Burgner on 5/27/19.
//  Copyright © 2019 Peter Burgner. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    // MARK: Properties
    @IBOutlet weak var imageView: UIImageView!
    var meme = Meme()
    
    // MARK: View Functions
    override func viewWillAppear(_ animated: Bool) {
        imageView.image = meme.memedImage
        let editButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(edit))
        navigationItem.rightBarButtonItem = editButton
        // TODO: hide tab bar
    }
    
    // MARK: Functions
    @objc func edit() {
        let controller = storyboard?.instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
        controller.meme = self.meme
        present(controller, animated: true, completion: nil)
    }

}
