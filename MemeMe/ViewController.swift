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
    
    struct Meme {
        var topText: String = ""
        var bottomText: String = ""
        var originalImage = UIImage()
        var memedImage = UIImage()
    }
    
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
        //     TODO:    shareButton.isEnabled =
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
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
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if bottom.isEditing {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillDisappear(_ notification:Notification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func save() -> Meme {
        return Meme(topText: top.text!, bottomText: bottom.text!, originalImage: imageView.image!, memedImage: generateMemedImage())
    }
    
    func generateMemedImage() -> UIImage {
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return memedImage
    }
    
    
    // MARK: NSNotifications
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
}

