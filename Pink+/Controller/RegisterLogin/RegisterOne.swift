//
//  RegisterOne.swift
//  Pink+
//
//  Created by Utkarsh Sharma on 19/09/20.
//

import UIKit
import SVProgressHUD
import SkyFloatingLabelTextField
import CDAlertView
import SwiftValidator

class RegisterOne: UIViewController, ValidationDelegate {

    @IBOutlet weak var nameTextField: SkyFloatingLabelTextField!
    var name = ""
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextField!
    var email = ""
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextField!
    var password = ""
    
    let validator = Validator()
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupToolbar()
        
        // call the 'keyboardWillShow' function when the view controller receive the notification that a keyboard is going to be shown
            NotificationCenter.default.addObserver(self, selector: #selector(RegisterOne.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
          
              // call the 'keyboardWillHide' function when the view controlelr receive notification that keyboard is going to be hidden
            NotificationCenter.default.addObserver(self, selector: #selector(RegisterOne.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        validator.registerField(emailTextField, rules: [RequiredRule(), EmailRule(message: "Invalid email")])
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
        nameTextField.inputAccessoryView = bar
        emailTextField.inputAccessoryView = bar
        passwordTextField.inputAccessoryView = bar
    }
    
    @objc func dismissMyKeyboard(){
        view.endEditing(true)
    }

    
    
    // MARK: IBFunctions
    @IBAction func nextBtnPressed(_ sender: Any) {
        name = nameTextField.text ?? ""
        email = emailTextField.text ?? ""
        password = passwordTextField.text ?? ""
        
        if checkExist(name: name, email: email, pass: password) {
            validator.validate(self)
        }
        
    }
    
    func checkExist(name: String, email: String, pass: String) -> Bool {
        if (name == ""){
            showError(content: "name")
            return false
        } else if (email == ""){
            showError(content: "email")
            return false
        } else if (pass == ""){
            showError(content: "password")
            return false
        } else {
            return true
        }
    }
    
    func showError(content: String){
        let alert = CDAlertView(title: "Oops, something's not right!", message: "Please enter your \(content).", type: .error)
        let doneAction = CDAlertViewAction(title: "Sure! 💪")
        alert.add(action: doneAction)
        alert.show()
    }
}


extension RegisterOne {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToRegisterTwo" {
            let destinationVC = segue.destination as! RegisterTwo
            destinationVC.name = name
            destinationVC.email = email
            destinationVC.password = password
        }
    }
    
    func validationSuccessful() {
        performSegue(withIdentifier: "goToRegisterTwo", sender: nil)
    }
    
    func validationFailed(_ errors:[(Validatable ,ValidationError)]) {
        let alert = CDAlertView(title: "Oops, something's wrong!", message: "This is not a valid email address. Please recheck.", type: .error)
        let doneAction = CDAlertViewAction(title: "Sure thing! 🤘")
        alert.add(action: doneAction)
        alert.show()
    }
}
