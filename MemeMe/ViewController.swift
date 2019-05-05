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
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var photoLibraryButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var top: UITextField!
    @IBOutlet weak var bottom: UITextField!
    let memeDelegate = MemeTextDelegate()
    
    // MARK: View Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        top.delegate = memeDelegate
        bottom.delegate = memeDelegate
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

    // MARK: Functions
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = image
            picker.dismiss(animated: false, completion: nil)
        }
    }

}

