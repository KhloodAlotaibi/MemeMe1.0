//
//  ViewController.swift
//  MemeMe1.0
//
//  Created by Khlood on 5/8/20.
//  Copyright © 2020 Khlood. All rights reserved.
//

import UIKit 

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet var myImageView: UIImageView!
    @IBOutlet var myTopTextField: UITextField!
    @IBOutlet var myBottomTextField: UITextField!
    @IBOutlet var myCameraButton: UIBarButtonItem!
    @IBOutlet var myShareButton: UIBarButtonItem!
    @IBOutlet var myToolbar: UIToolbar!
    @IBOutlet var myNavigationBar: UINavigationBar!
    
    let imagePicker = UIImagePickerController()
    var memedImage = UIImage()
    
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 30)!,
        NSAttributedString.Key.strokeWidth:  -3.0
    ]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // to check if camera is available
        myCameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        myTopTextField.delegate = self
        myBottomTextField.delegate = self
        //set default text attributes
        myTopTextField.defaultTextAttributes = memeTextAttributes
        myBottomTextField.defaultTextAttributes = memeTextAttributes
        //set default text
        myTopTextField.text = "TOP"
        myBottomTextField.text = "BOTTOM"
        //set text Alignment
        myTopTextField.textAlignment = .center
        myBottomTextField.textAlignment = .center
        // to disable share button before picking an image
        myShareButton.isEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    @IBAction func myAlbumButtonClicked(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func myCameraButtonClicked(_ sender: Any) {
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    // UIImagePickerControllerDelegate Methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            myImageView.contentMode = .scaleAspectFit
            myImageView.image = pickedImage
            myShareButton.isEnabled = true
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Remove default text
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
    }
    
    // Dismissing the keyboard
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Keyboard show\hide notifications\methods
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)

    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if myBottomTextField.isEditing {
        view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0
    }

    // to generate the meme Image
    
    func generateMemedImage() -> UIImage {
        
        // Hide toolbar and navbar
        myToolbar.isHidden = true
        myNavigationBar.isHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Show toolbar and navbar
        myToolbar.isHidden = false
        myNavigationBar.isHidden = false
        
        return memedImage
    }
    
    // save meme image
    
    func save() {
        let meme = Meme(topText: myTopTextField.text!, bottomText: myBottomTextField.text!, orgImage: myImageView.image!, memeImage: memedImage)
    }
    
    // Action to share meme image
    
    @IBAction func myShareButtonClicked(_ sender: Any) {
        let memeImage = generateMemedImage()
        let activityController = UIActivityViewController(activityItems: [memeImage], applicationActivities: nil)
        activityController.completionWithItemsHandler = { activity, success, items, error in
            self.save()
            self.dismiss(animated: true, completion: nil)
        }
        self.present(activityController, animated: true, completion: nil)
    }
    
    // cancel editting image
    
    @IBAction func myCancelButtonClicked(_ sender: Any) {
        myImageView.image = nil
        myTopTextField.text = "TOP"
        myBottomTextField.text = "BOTTOM"
    }
}
