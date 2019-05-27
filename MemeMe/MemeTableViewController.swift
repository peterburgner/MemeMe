//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Peter Burgner on 5/27/19.
//  Copyright © 2019 Peter Burgner. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {
    
    // MARK: Properties
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let memes = [Meme(topText: "Top text", bottomText: "Bottom", originalImage: UIImage(), memedImage: UIImage())]
    
    
    // MARK: Table Functions
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: Add detail view
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableViewCell")!
        
        cell.textLabel?.text = memes[indexPath.row].topText
        cell.imageView?.image = memes[indexPath.row].memedImage
        
        return cell
    }
}
