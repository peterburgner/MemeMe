//
//  Meme.swift
//  MemeMe
//
//  Created by Peter Burgner on 5/27/19.
//  Copyright © 2019 Peter Burgner. All rights reserved.
//

import UIKit

class Meme {
    var topText: String
    var bottomText: String
    var originalImage: UIImage
    var memedImage: UIImage
    
    init(topText: String, bottomText: String, originalImage: UIImage, memedImage: UIImage) {
        self.topText = topText
        self.bottomText = bottomText
        self.originalImage = originalImage
        self.memedImage = memedImage
    }
    
    init() {
        self.topText = ""
        self.bottomText = ""
        self.originalImage = UIImage()
        self.memedImage = UIImage()
    }
    
    func isEmpty() -> Bool {
        return ( self.topText == "" && self.bottomText == "" && self.originalImage == UIImage() && self.memedImage == UIImage() )
    }
    
}
