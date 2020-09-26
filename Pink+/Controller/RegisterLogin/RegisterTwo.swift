//
//  RegisterTwo.swift
//  Pink+
//
//  Created by Utkarsh Sharma on 19/09/20.
//

import UIKit
import SKCountryPicker
import SkyFloatingLabelTextField
import CDAlertView

class RegisterTwo: UIViewController {

    @IBOutlet weak var countryButton: UIButton!
    @IBOutlet weak var ageTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var genderSegmentedControl: UISegmentedControl!
    
    var name = ""
    var email = ""
    var password = ""
    
    var usersCountry = "India"
    var usersAge = ""
    var usersGender = ""
    var proceedFromCountry = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupToolbar()

        guard CountryManager.shared.currentCountry != nil else {
                self.countryButton.setTitle("Your country of residence?", for: .normal)
                return
            }
        
        // call the 'keyboardWillShow' function when the view controller receive the notification that a keyboard is going to be shown
            NotificationCenter.default.addObserver(self, selector: #selector(RegisterTwo.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
          
              // call the 'keyboardWillHide' function when the view controlelr receive notification that keyboard is going to be hidden
            NotificationCenter.default.addObserver(self, selector: #selector(RegisterTwo.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        countryButton.clipsToBounds = true
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
        ageTextField.inputAccessoryView = bar
    }
    
    @objc func dismissMyKeyboard(){
        view.endEditing(true)
    }
    
    
    
    //MARK: IBAction
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToRegisterThree" {
            let destinationVC = segue.destination as! RegisterThree
            destinationVC.name = name
            destinationVC.email = email
            destinationVC.password = password
            destinationVC.country = usersCountry
            destinationVC.age = usersAge
            destinationVC.gender = usersGender
        }
    }

    @IBAction func nextBtnPressed(_ sender: Any) {
        if proceedFromCountry {
            usersAge = ageTextField.text ?? ""
            if(checkValidation(age: usersAge)){
                performSegue(withIdentifier: "goToRegisterThree", sender: nil)
            } else {
                showError(title: "Oops, we need this!", message: "Please enter a valid age.")
            }
            
        } else {
            showError(title: "Oops, you missed something!", message: "Please select a country of residence.")
        }
    }
    
    @IBAction func genderChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            usersGender = "Female"
        case 1:
            usersGender = "Male"
        case 2:
            usersGender = "Others"
        default:
            usersGender = "Female"
            break;
        }
    }
    
    @IBAction func countryButtonPressed(_ sender: Any) {
        
        _ = CountryPickerWithSectionViewController.presentController(on: self) { [weak self] (country: Country) in

          guard let self = self else { return }

            self.countryButton.setTitle(country.countryName, for: .normal)
            self.proceedFromCountry = true
            self.usersCountry = country.countryName
        }
        
    }
    
    func checkValidation(age: String) -> Bool {
        if(age == ""){
            return false
        } else {
            return true
        }
    }
    
    func showError(title: String, message: String){
        let alert = CDAlertView(title: title, message: message, type: .error)
        let doneAction = CDAlertViewAction(title: "Okay! 🤙")
        alert.add(action: doneAction)
        alert.show()
    }
    
}
