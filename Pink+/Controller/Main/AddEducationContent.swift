//
//  AddEducationContent.swift
//  Pink+
//
//  Created by Utkarsh Sharma on 21/09/20.
//

import UIKit
import CDAlertView
import FirebaseStorage
import FirebaseDatabase
import SkyFloatingLabelTextField
import MBAutoGrowingTextView
import SVProgressHUD
import MobileCoreServices

class AddEducationContent: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var titleField: SkyFloatingLabelTextField!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var contentField: UITextView!
    @IBOutlet weak var typeOfContent: UISegmentedControl!
    @IBOutlet weak var typeOfCategory: UISegmentedControl!
    @IBOutlet weak var uploadButton: UIButton!
    
    var contentTitle = ""
    var content = ""
    var contentType = "Blog"
    var contentCategory = "General"
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupToolbar()
        
        uploadButton.isEnabled = true
        
        ref = Database.database().reference()
        
        contentField.placeholder = "Your content goes here..."
        
        usernameLabel.text = "by  @\(UserDefaults.standard.string(forKey: "name") ?? "")"
        
//        // call the 'keyboardWillShow' function when the view controller receive the notification that a keyboard is going to be shown
//            NotificationCenter.default.addObserver(self, selector: #selector(Share.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
//
//              // call the 'keyboardWillHide' function when the view controlelr receive notification that keyboard is going to be hidden
//            NotificationCenter.default.addObserver(self, selector: #selector(Share.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
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
        contentField.inputAccessoryView = bar
    }
    
    @objc func dismissMyKeyboard(){
        view.endEditing(true)
    }
    
    @IBAction func changeCategory(_ sender: UISegmentedControl) {
        if(sender == typeOfCategory){
            print("cat type")
            switch sender.selectedSegmentIndex {
            case 0:
                contentCategory = "Overview"
            case 1:
                contentCategory = "Detection"
            case 2:
                contentCategory = "Diagnosis"
            case 3:
                contentCategory = "Prognosis"
            case 4:
                contentCategory = "Myths"
            default:
                contentCategory = "Overview"
                break;
            }
        }
    }
    
    @IBAction func changeType(_ sender: UISegmentedControl) {
        if(sender == typeOfContent){
            print("cont type")
            switch sender.selectedSegmentIndex {
            case 0:
                contentType = "Blog"
            case 1:
                contentType = "Photo"
            case 2:
                contentType = "Video"
            default:
                contentType = "Blog"
                break;
            }
        }
    }
    
    @IBAction func uploadButtonPressed(_ sender: Any) {
        
        if checkValidity() {
            SVProgressHUD.show()
            
            let username = UserDefaults.standard.string(forKey: "name")
            
            if(contentType=="Image"){
                
                uploadButton.isEnabled = false
                ImagePickerManager().pickImage(self){ image in
                    if let data = image.pngData() {
                        
                        let username = UserDefaults.standard.string(forKey: "name")
                        
                        let servername = username! + "educate.png"
                        
                        FirebaseStorageManager().uploadImageData(data: data, serverFileName: servername) { (isSuccess, url) in
                            self.ref.child("content").child(UserDefaults.standard.string(forKey: "name")!).child(self.contentTitle).setValue(["Title": self.contentTitle,
                                                                            "Content": self.content,
                                                                            "Author": username,
                                                                            "Type": self.contentType,
                                                                            "Cat": self.contentCategory,
                                                                            "Media": url])
                            SVProgressHUD.dismiss()
                            let alert = CDAlertView(title: "Thank you!", message: "Content like that make the difference.", type: .success)
                            alert.show()
                            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                            
                            self.uploadButton.isEnabled = true
                            
                            DispatchQueue.main.asyncAfter(deadline:.now() + 1.0, execute: {
                                self.performSegue(withIdentifier: "goBackToMainFromAddEducate", sender: nil)
                            })
                        }
                    }
                }
                
            } else if (contentType=="Video"){
                
                uploadButton.isEnabled = false
                ImagePickerManager().pickImage(self){ image in
                    if let data = image.pngData() {
                        
                        let username = UserDefaults.standard.string(forKey: "name")
                        
                        let servername = username! + "educate.png"
                        
                        FirebaseStorageManager().uploadImageData(data: data, serverFileName: servername) { (isSuccess, url) in
                            self.ref.child("content").child(UserDefaults.standard.string(forKey: "name")!).child(self.contentTitle).setValue(["Title": self.contentTitle,
                                                                            "Content": self.content,
                                                                            "Author": username,
                                                                            "Type": self.contentType,
                                                                            "Cat": self.contentCategory,
                                                                            "Media": url])
                            SVProgressHUD.dismiss()
                            let alert = CDAlertView(title: "Thank you!", message: "Content like that make the difference.", type: .success)
                            alert.show()
                            
                            self.uploadButton.isEnabled = true
                            
                            DispatchQueue.main.asyncAfter(deadline:.now() + 1.0, execute: {
                                self.performSegue(withIdentifier: "goBackToMainFromAddEducate", sender: nil)
                            })
                        }
                    }
                }
                
            } else if (contentType=="Blog"){
                
                uploadButton.isEnabled = false
                let defImage = UIImage(named: "educateDef")
                
                if let data = defImage!.pngData() {
                    
                    let servername = "educate.png"
                    
                    FirebaseStorageManager().uploadImageData(data: data, serverFileName: servername) { (isSuccess, url) in
                        self.ref.child("content").child(UserDefaults.standard.string(forKey: "name")!).child(self.contentTitle).setValue(["Title": self.contentTitle,
                                                                        "Content": self.content,
                                                                        "Author": username,
                                                                        "Type": self.contentType,
                                                                        "Cat": self.contentCategory,
                                                                        "Media": url])
                        SVProgressHUD.dismiss()
                        let alert = CDAlertView(title: "Thank you!", message: "Content like that make the difference.", type: .success)
                        alert.show()
                        
                        self.uploadButton.isEnabled = true
                        
                        DispatchQueue.main.asyncAfter(deadline:.now() + 1.0, execute: {
                            self.performSegue(withIdentifier: "goBackToMainFromAddEducate", sender: nil)
                        })
                    }
                }
            }
            
        }
        
    }
    
    
    func checkValidity() -> Bool {
        contentTitle = titleField.text ?? ""
        content = contentField.text
        
        if (contentTitle == "") {
            let alert = CDAlertView(title: "Something feels wrong, Mr. Stark", message: "Please enter a title for your content.", type: .error)
            let doneAction = CDAlertViewAction(title: "Sure! 💪")
            alert.add(action: doneAction)
            alert.show()
            return false
        } else if (content == "") {
            let alert = CDAlertView(title: "Excuse me, wordless content?", message: "Please enter some content to your educational material.", type: .error)
            let doneAction = CDAlertViewAction(title: "Sure! 💪")
            alert.add(action: doneAction)
            alert.show()
            return false
        } else {
            return true
        }
    }
}
