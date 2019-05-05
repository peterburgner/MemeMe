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
        
        resetButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        photoLibraryButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
        prepareUI()
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    func prepareUI() {
        // shareButton
        if (top.text != "TOP") && (bottom.text != "BOTTOM") && (imageView.image != nil) {
            shareButton.isEnabled = true
        } else {
            shareButton.isEnabled = false
        }
        // reset button
        if (top.text != "TOP") || (bottom.text != "BOTTOM") || (imageView.image != nil) {
            resetButton.isEnabled = true
        }
    }
    
    func reset() {
        imageView.image = UIImage()
        top.text = "TOP"
        bottom.text = "BOTTOM"
        resetButton.isEnabled = false
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
    
    @IBAction func shareMeme(_ sender: Any) {
        let meme = saveMeme()
        let activityController = UIActivityViewController(activityItems: [meme.memedImage], applicationActivities: nil)
        present(activityController, animated: true, completion: nil)
    }
    
    @IBAction func resetAlert(_ sender: AnyObject) {
        let alertController = UIAlertController(title: "Reset Meme", message: "Your meme will be deleted. Proceed?", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .default) { action in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(cancel)
        let okay = UIAlertAction(title: "OK", style: .default) { action in
            self.dismiss(animated: true, completion: nil)
            self.reset()
        }
        alertController.addAction(okay)

        present(alertController, animated: true, completion: nil)
    }

    
    // MARK: Functions
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = image
            picker.dismiss(animated: false, completion: nil)
            prepareUI()
        }
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if bottom.isEditing {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillDisappear(_ notification:Notification) {
        view.frame.origin.y = 0
        prepareUI()
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func saveMeme() -> Meme {
        return Meme(topText: top.text!, bottomText: bottom.text!, originalImage: imageView.image!, memedImage: generateMemedImage())
    }
    
    func generateMemedImage() -> UIImage {
        
        let subviews = view.subviews
        subviews[0].isHidden = true
        subviews[2].isHidden = true
        // Render view to an image
        UIGraphicsBeginImageContextWithOptions(self.view.frame.size, false, 0)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        subviews[0].isHidden = false
        subviews[2].isHidden = false
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

