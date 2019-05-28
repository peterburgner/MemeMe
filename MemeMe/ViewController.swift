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

    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var photoLibraryButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var top: UITextField!
    @IBOutlet weak var bottom: UITextField!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var toolbar: UIToolbar!
    
    let memeDelegate = MemeTextDelegate()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 30)!,
        NSAttributedString.Key.strokeWidth: -5
    ]
    
    
    // MARK: View Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTextfield(textfield: top)
        configureTextfield(textfield: bottom)
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
    }
    
    func configureTextfield(textfield: UITextField) {
        textfield.delegate = memeDelegate
        textfield.defaultTextAttributes = memeTextAttributes
        textfield.textAlignment = NSTextAlignment.center
    }
    
    
    // MARK: IBActions
    @IBAction func pickImage() {
        presentImagePickerWith(sourceType: UIImagePickerController.SourceType.photoLibrary)
    }

    @IBAction func takePhoto() {
        presentImagePickerWith(sourceType: UIImagePickerController.SourceType.camera)
    }
    
    func presentImagePickerWith(sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        present(imagePicker, animated:true, completion:nil)
        prepareUI()
    }
       
    @IBAction func cancel(_ sender: Any) {
        let controller = storyboard!.instantiateViewController(withIdentifier: "MemeTabBarController") as! UITabBarController
        show(controller, sender: self)
    }
    
    @IBAction func shareMeme(_ sender: Any) {
        let generatedMemeImage = generateMemedImage()
        let activityController = UIActivityViewController(activityItems: [generatedMemeImage], applicationActivities: nil)
        activityController.completionWithItemsHandler = {
            (activity, completed, items, error) in
            if (completed){
                self.saveMeme(generatedMemeImage: generatedMemeImage)
            }
        }
        present(activityController, animated: true, completion: nil)
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
    
    func saveMeme(generatedMemeImage: UIImage) {
        let meme = Meme(topText: top.text!, bottomText: bottom.text!, originalImage: imageView.image!, memedImage: generatedMemeImage)
        appDelegate.memes.append(meme)
    }
    
    func generateMemedImage() -> UIImage {
        
        navigationBar.isHidden = true
        toolbar.isHidden = true
        // Render view to an image
        UIGraphicsBeginImageContextWithOptions(self.view.frame.size, false, 0)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        navigationBar.isHidden = false
        toolbar.isHidden = false
        return memedImage
    }
    
    // MARK: NSNotifications
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
}

