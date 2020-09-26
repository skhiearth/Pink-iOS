//
//  Login.swift
//  Pink+
//
//  Created by Utkarsh Sharma on 20/09/20.
//

import UIKit
import SkyFloatingLabelTextField
import FirebaseAuth
import FirebaseDatabase
import SwiftValidator
import CDAlertView
import SVProgressHUD

class Login: UIViewController, ValidationDelegate {
    
    @IBOutlet weak var emailAddressField: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordField: SkyFloatingLabelTextField!
    var email = ""
    var password = ""
    
    let validator = Validator()
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupToolbar()
        
        ref = Database.database().reference()
        
        // call the 'keyboardWillShow' function when the view controller receive the notification that a keyboard is going to be shown
            NotificationCenter.default.addObserver(self, selector: #selector(Login.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
          
              // call the 'keyboardWillHide' function when the view controlelr receive notification that keyboard is going to be hidden
            NotificationCenter.default.addObserver(self, selector: #selector(Login.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        validator.registerField(emailAddressField, rules: [RequiredRule(), EmailRule(message: "Invalid email")])
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
        emailAddressField.inputAccessoryView = bar
        passwordField.inputAccessoryView = bar
    }
    
    @objc func dismissMyKeyboard(){
        view.endEditing(true)
    }
    
    @IBAction func authenticateBtnPressed(_ sender: Any) {
        
        SVProgressHUD.show()
        
        email = emailAddressField.text ?? ""
        password = passwordField.text ?? ""
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            if(error != nil){
                SVProgressHUD.dismiss()
                let alert = CDAlertView(title: "Something went wrong!", message: error!.localizedDescription, type: .error)
                let doneAction = CDAlertViewAction(title: "Okay! 🤙")
                alert.add(action: doneAction)
                alert.show()
            } else {
                if let authResult = authResult {
                    SVProgressHUD.dismiss()
                    UserDefaults.standard.set(authResult.user.uid, forKey: "uid")
                    
                    self!.ref.child("users").child(authResult.user.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                        
                      let value = snapshot.value as! NSDictionary
                        
                        UserDefaults.standard.set(authResult.user.uid, forKey: "uid")
                        
                      let name = value["Name"] as! String
                        UserDefaults.standard.set(name, forKey: "name")
                        
                        let type = value["Type"] as! String
                        UserDefaults.standard.set(type, forKey: "type")
                        
                        let gender = value["Gender"] as! String
                        UserDefaults.standard.set(gender, forKey: "gender")
                        
                        let email = value["Email"] as! String
                        UserDefaults.standard.set(email, forKey: "email")
                        
                        let country = value["Country"] as! String
                        UserDefaults.standard.set(country, forKey: "country")
                        
                        let age = value["Age"] as! String
                        UserDefaults.standard.set(age, forKey: "age")
                        
                        SVProgressHUD.showSuccess(withStatus: "Authentication successful! Welcome back.")
                        let storyBoard : UIStoryboard = UIStoryboard(name: "Pink", bundle:nil)
                        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Stories") as! Stories
                        nextViewController.modalPresentationStyle = .fullScreen
                        self!.present(nextViewController, animated:true, completion:nil)
                        
                      }) { (error) in
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
}

extension Login {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    func validationSuccessful() {
//        performSegue(withIdentifier: "goToRegisterTwo", sender: nil)
    }
    
    func validationFailed(_ errors:[(Validatable ,ValidationError)]) {
        let alert = CDAlertView(title: "Oops, something's wrong!", message: "This is not a valid email address. Please recheck.", type: .error)
        let doneAction = CDAlertViewAction(title: "Sure thing! 🤘")
        alert.add(action: doneAction)
        alert.show()
    }
}
