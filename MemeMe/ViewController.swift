//
//  ViewController.swift
//  MemeMe
//
//  Created by Peter Burgner on 5/4/19.
//  Copyright © 2019 Peter Burgner. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: Properties
    @IBOutlet weak var resetButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var photoLibraryButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var top: UITextField!
    @IBOutlet weak var bottom: UITextField!
    let memeDelegate = MemeTextDelegate()
    
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 30)!,
        NSAttributedString.Key.strokeWidth: -5
    ]
    
    // MARK: View Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        top.delegate = memeDelegate
        top.defaultTextAttributes = memeTextAttributes
        top.textAlignment = NSTextAlignment.center
        bottom.delegate = memeDelegate
        bottom.defaultTextAttributes = memeTextAttributes
        bottom.textAlignment = NSTextAlignment.center
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        photoLibraryButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
    }
    
    // MARK: IBActions
    @IBAction func pickImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }


    @IBAction func takePhoto() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerController.SourceType.camera
        imagePicker.cameraDevice = UIImagePickerController.CameraDevice.rear
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func reset() {
        imageView.image = UIImage()
        top.text = "TOP"
        bottom.text = "BOTTOM"
    }

    // MARK: Functions
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = image
            picker.dismiss(animated: false, completion: nil)
        }
    }
    
    

}

