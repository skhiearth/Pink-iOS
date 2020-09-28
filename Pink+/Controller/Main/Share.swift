//
//  Share.swift
//  Pink+
//
//  Created by Utkarsh Sharma on 27/09/20.
//

import UIKit
import SkyFloatingLabelTextField
import FirebaseDatabase
import FirebaseAuth
import CDAlertView
import MBAutoGrowingTextView
import FirebaseStorage
import SVProgressHUD

class Share: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var titleField: SkyFloatingLabelTextField!
    @IBOutlet weak var storyContent: UITextView!
    @IBOutlet weak var shareBtn: UIButton!
    
    var storyTitle = ""
    var content = ""
    
    var imagePicker = UIImagePickerController()
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.shareBtn.isEnabled = true

        setupToolbar()
        
        ref = Database.database().reference()
        
        storyContent.placeholder = "Pen your story here..."
        
        usernameLabel.text = "by  @\(UserDefaults.standard.string(forKey: "name") ?? "")"
        
        // call the 'keyboardWillShow' function when the view controller receive the notification that a keyboard is going to be shown
            NotificationCenter.default.addObserver(self, selector: #selector(Share.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
          
              // call the 'keyboardWillHide' function when the view controlelr receive notification that keyboard is going to be hidden
            NotificationCenter.default.addObserver(self, selector: #selector(Share.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: Keyboard Handling
    @objc func keyboardWillShow(notification: NSNotification) {
            
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
           // if keyboard size is not available for some reason, dont do anything
           return
        }
      
      // move the root view up by the distance of keyboard height
      self.view.frame.origin.y = 0 - keyboardSize.height
    }

    @objc func keyboardWillHide(notification: NSNotification) {
      // move back the root view origin to zero
      self.view.frame.origin.y = 0
    }
    
    func setupToolbar(){
        //Create a toolbar
        let bar = UIToolbar()
        //Create a done button with an action to trigger our function to dismiss the keyboard
        let doneBtn = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissMyKeyboard))
        //Create a felxible space item so that we can add it around in toolbar to position our done button
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        //Add the created button items in the toobar
        bar.items = [flexSpace, flexSpace, doneBtn]
        bar.sizeToFit()
        //Add the toolbar to our textfield
        titleField.inputAccessoryView = bar
        storyContent.inputAccessoryView = bar
    }
    
    @objc func dismissMyKeyboard(){
        view.endEditing(true)
    }
    
    
    // MARK: IBActions

    @IBAction func shareBtnPressed(_ sender: Any) {
        
        if checkValidity() {
            ImagePickerManager().pickImage(self){ image in
                
                SVProgressHUD.show()
                
                self.shareBtn.isEnabled = false
                
                let username = UserDefaults.standard.string(forKey: "name")
                
                let servername = username! + ".png"
                
                if let data = image.pngData() { // convert your UIImage into Data object using png representation
                    FirebaseStorageManager().uploadImageData(data: data, serverFileName: servername) { (isSuccess, url) in
                            self.ref.child("stories").child(UserDefaults.standard.string(forKey: "name")!).child(self.storyTitle).setValue(["Title": self.storyTitle,
                                                                                         "Content": self.content,
                                                                                         "Author": username,
                                                                                         "Image": url])
                        SVProgressHUD.dismiss()
                            let alert = CDAlertView(title: "Thank you!", message: "Stories like that make the difference.", type: .success)
                            alert.show()
                        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                        
                        self.shareBtn.isEnabled = true
                        
                            DispatchQueue.main.asyncAfter(deadline:.now() + 2.0, execute: {
                                self.performSegue(withIdentifier: "goBackToStoriesFromShare", sender: nil)
                            })
                       }
                }
            }
        }
    }
    
    func checkValidity() -> Bool {
        storyTitle = titleField.text ?? ""
        content = storyContent.text
        
        if (storyTitle == "") {
            let alert = CDAlertView(title: "Something feels wrong, Mr. Stark", message: "Please enter a title for your story.", type: .error)
            let doneAction = CDAlertViewAction(title: "Sure! 💪")
            alert.add(action: doneAction)
            alert.show()
            return false
        } else if (content == "") {
            let alert = CDAlertView(title: "A story without words?", message: "Please enter some content to your story.", type: .error)
            let doneAction = CDAlertViewAction(title: "Sure! 💪")
            alert.add(action: doneAction)
            alert.show()
            return false
        } else {
            return true
        }
    }
    
}
