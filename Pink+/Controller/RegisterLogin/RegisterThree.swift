//
//  RegisterThree.swift
//  Pink+
//
//  Created by Utkarsh Sharma on 28/09/20.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import CDAlertView
import SVProgressHUD

class RegisterThree: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var categoryPicker: UIPickerView!
    
    var name = ""
    var email = ""
    var password = ""
    var country = ""
    var age = ""
    var gender = ""
    
    var pickerData: [String] = [String]()
    var selectedCategory = "Survivor"
    let defaults = UserDefaults.standard
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        self.categoryPicker.delegate = self
        self.categoryPicker.dataSource = self

        pickerData = ["Survivor", "Medical Professional", "Research Professional", "Patient", "General Public"]
    }
    
    @IBAction func finishBtnPressed(_ sender: Any) {
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "GetStarted") as! GetStarted
//        self.present(nextViewController, animated:true, completion:nil)
        
        SVProgressHUD.show()
        
        Auth.auth().createUser(withEmail: email, password: password) { AuthResult, error in
            if(error != nil){
                SVProgressHUD.dismiss()
                self.showError(title: "Something went wrong!", message: error!.localizedDescription)
            } else {
                if let AuthResult = AuthResult {
                    self.ref.child("users").child(AuthResult.user.uid).setValue(["Name": self.name,
                                                                                 "Email": self.email,
                                                                                 "Country": self.country,
                                                                                 "Age": self.age,
                                                                                 "Gender": self.gender,
                                                                                 "Type": self.selectedCategory])
                    UserDefaults.standard.set(AuthResult.user.uid, forKey: "uid")
                    UserDefaults.standard.set(self.name, forKey: "name")
                    UserDefaults.standard.set(self.selectedCategory, forKey: "type")
                    UserDefaults.standard.set(self.gender, forKey: "gender")
                    UserDefaults.standard.set(self.email, forKey: "email")
                    UserDefaults.standard.set(self.country, forKey: "country")
                    UserDefaults.standard.set(self.age, forKey: "age")
                    
                    SVProgressHUD.dismiss()
                    
                    SVProgressHUD.showSuccess(withStatus: "Authentication successful! Welcome.")
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Pink", bundle:nil)
                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Stories") as! Stories
                    nextViewController.modalPresentationStyle = .fullScreen
                    self.present(nextViewController, animated:true, completion:nil)
                }
            }
        }
    }
    
    func showError(title: String, message: String){
        let alert = CDAlertView(title: title, message: message, type: .error)
        let doneAction = CDAlertViewAction(title: "Okay! 🤙")
        alert.add(action: doneAction)
        alert.show()
    }
    
}

extension RegisterThree {
    // Number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent  component: Int) {
        selectedCategory = pickerData[row]
    }
}
