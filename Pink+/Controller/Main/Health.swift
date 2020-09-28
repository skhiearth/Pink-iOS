//
//  Health.swift
//  Pink+
//
//  Created by Utkarsh Sharma on 28/09/20.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import CDAlertView
import SwiftyJSON
import WatchConnectivity
import Alamofire
import SVProgressHUD

class Health: UIViewController {

    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var lumpButton: UIButton!
    @IBOutlet weak var thicknessButton: UIButton!
    @IBOutlet weak var irritationButton: UIButton!
    @IBOutlet weak var skinButton: UIButton!
    @IBOutlet weak var painButton: UIButton!
    @IBOutlet weak var dischargeButton: UIButton!
    
    var lump = "No"
    var thickness = "No"
    var irritation = "No"
    var skin = "No"
    var pain = "No"
    var discharge = "No"
    
    var bmifield: UITextField!
    var glucoseField: UITextField!
    var insulinField: UITextField!
    var HOMAfield: UITextField!
    var leptinField: UITextField!
    var AdiponectinField: UITextField!
    var ResistinField: UITextField!
    var mcp1field: UITextField!
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()

        userLabel.text = "Hi, \(UserDefaults.standard.string(forKey: "name") ?? "")"
    }
    
    @IBAction func reportEvalButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "ML based Report Evaluation", message: "You can self-screen using your blood test reports or upload cytology reports for a medical professional to examine using Machine Learning.", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Blood Test Reports", style: .default, handler: { (_) in
            self.displayForm(message: "Please enter your blood test readings to get a ML-based evaluation for possible presence of Breast Cancer.")
        }))
        
        alert.addAction(UIAlertAction(title: "Cytology Reports", style: .default, handler: { (_) in
            
        }))

        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { (_) in
            print("User click Dismiss button")
        }))

        self.present(alert, animated: true, completion: {
            print("Completion block")
        })
    }
    
    func displayForm(message:String){
            //create alert
            let alert = UIAlertController(title: "Blood Test Evaluation", message: message, preferredStyle: .alert)
            
            //create cancel button
            let cancelAction = UIAlertAction(title: "Cancel" , style: .cancel)
            
            //create save button
            let saveAction = UIAlertAction(title: "Submit", style: .default) { (action) -> Void in
               //validation logic goes here
                if((self.bmifield.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)!
                    || (self.glucoseField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)!
                    || (self.insulinField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)!
                    || (self.HOMAfield.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)!
                    || (self.leptinField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)!
                    || (self.AdiponectinField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)!
                    || (self.ResistinField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)!
                    || (self.mcp1field.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)! ){
                    self.bmifield.text = ""
                    self.glucoseField.text = ""
                    self.insulinField.text = ""
                    self.HOMAfield.text = ""
                    self.leptinField.text = ""
                    self.AdiponectinField.text = ""
                    self.ResistinField.text = ""
                    self.mcp1field.text = ""
                    
                    self.displayForm(message: "One of the values entered was invalid. Please enter all information")
                }
                
                // handle api here
                let age = Int(UserDefaults.standard.string(forKey: "age")!)!
                
                let bmi: String! = self.bmifield.text!
                let glucose: String! = self.glucoseField.text!
                let insulin: String! = self.insulinField.text!
                let homa: String! = self.HOMAfield.text!
                let leptin: String! = self.leptinField.text!
                let adiponectin: String! = self.AdiponectinField.text!
                let resistin: String! = self.ResistinField.text!
                let mcp1: String! = self.mcp1field.text!
                
                
                let stringToPass = "\(age),\(bmi ?? ""),\(glucose ?? ""),\(insulin ?? ""),\(homa ?? ""),\(leptin ?? ""),\(adiponectin ?? ""),\(resistin ?? ""),\(mcp1 ?? "")"
                
                print(stringToPass)
                
                let parameters = ["data": stringToPass]
                
                let url = "https://bcpd3.herokuapp.com/predict"
                
                SVProgressHUD.show(withStatus: "Calculating....")
                
                AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response) in
                    switch (response.result) {
                        case .success(let data):
                            SVProgressHUD.dismiss()
                            guard let json = data as? [String : AnyObject] else {
                                SVProgressHUD.showError(withStatus: "Failed to get expected response from webserver.")
                                return
                            }

                            // Then make sure you get the actual key/value types you expect
                            let pred = json["Prediction"] as? String
                            if(pred=="Benign"){
                                let alert = CDAlertView(title: "Benign", message: "According to our ML evaluation, you don't seem to have presence of a cancerous breast cancer tumor. This model doesn't have an extraordinally high precision for benign tumors. We suggest you to consult a doctor at the earliest for clarification or upload get your cytology reports examined.", type: .success)
                                let doneAction = CDAlertViewAction(title: "Thanks! 😁")
                                alert.add(action: doneAction)
                                alert.show()
                            } else {
                                let alert = CDAlertView(title: "Malignant", message: "According to our ML evaluation, it seems like there might be traces of a cancerous breast cancer tumor. For clarification, please get a bioposy and mammography checked by an expert. Pink+ provides Cytology evaluation, and mammography evaluation is coming soon. We have a high precision for detecting this, so instead of being anxious, you should be relaxed and confident on possibly detecting it early. Please consult an expert at the earliest for the next course of action.", type: .notification)
                                let doneAction = CDAlertViewAction(title: "Sure!")
                                alert.add(action: doneAction)
                                alert.show()
                            }
                            
                            break
                        case .failure(let error):
                            SVProgressHUD.dismiss()
                            SVProgressHUD.showError(withStatus: "Something went wrong. It's not you, it's us.")
                            print(Error.self)
                    }
                    SVProgressHUD.dismiss()
                }
            }
            
            //add button to alert
            alert.addAction(cancelAction)
            alert.addAction(saveAction)
            
            alert.addTextField(configurationHandler: {(textField: UITextField!) in
                textField.placeholder = "Enter BMI (e.g., 23.5)"
                textField.keyboardType = .decimalPad
                self.bmifield = textField
            })
            
            alert.addTextField(configurationHandler: {(textField: UITextField!) in
                textField.placeholder = "Enter glucose reading (e.g., 92)"
                textField.keyboardType = .decimalPad
                self.glucoseField = textField
            })
            
            alert.addTextField(configurationHandler: {(textField: UITextField!) in
                textField.placeholder = "Enter insulin reading (e.g., 2.707)"
                textField.keyboardType = .decimalPad
                self.insulinField = textField
            })
        
            alert.addTextField(configurationHandler: {(textField: UITextField!) in
                textField.placeholder = "Enter HOMA reading (e.g., 0.46)"
                textField.keyboardType = .decimalPad
                self.HOMAfield = textField
            })
            
            alert.addTextField(configurationHandler: {(textField: UITextField!) in
                textField.placeholder = "Enter Leptin reading (e.g., 8.807)"
                textField.keyboardType = .decimalPad
                self.leptinField = textField
            })
            
            alert.addTextField(configurationHandler: {(textField: UITextField!) in
                textField.placeholder = "Enter Adiponectin reading (e.g., 9.702)"
                textField.keyboardType = .decimalPad
                self.AdiponectinField = textField
            })
            
            alert.addTextField(configurationHandler: {(textField: UITextField!) in
                textField.placeholder = "Enter Resistin reading (e.g., 7.995)"
                textField.keyboardType = .decimalPad
                self.ResistinField = textField
            })
            
            alert.addTextField(configurationHandler: {(textField: UITextField!) in
                textField.placeholder = "Enter MCP.1 reading (e.g., 417.11)"
                textField.keyboardType = .decimalPad
                self.mcp1field = textField
            })
        
            self.present(alert, animated: true, completion: nil)
        }
    
    func updateHealthData() {
        // get the current date and time
        let currentDateTime = Date()

        // initialize the date formatter and set the style
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .medium
        
        self.ref.child("healthData").child(UserDefaults.standard.string(forKey: "uid")!).child(formatter.string(from: currentDateTime)).setValue(["Lump": self.lump,
                                                                                                                                                  "Thickness or Swelling": self.thickness,
                                                                                                                                                  "Skin Irritation": self.irritation,
                                                                                                                                                  "Redness or Flaky Skin": self.skin,
                                                                                                                                                  "Pain or General Discomfort": self.pain,
                                                                                                                                                  "Eccentric Discharge": self.discharge])
        
        let alert = CDAlertView(title: "Logged!", message: "Your symptoms were logged on \(formatter.string(from: currentDateTime)). You can share your symptom history with your healthcare provider if you want.", type: .success)
        let doneAction = CDAlertViewAction(title: "Noted! 😁")
        alert.add(action: doneAction)
        alert.show()
    }
    
    
    @IBAction func shareBtnPressed(_ sender: Any) {
        getData()
    }
    
    func getData() {
        let userID = Auth.auth().currentUser?.uid
        ref.child("healthData").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
          let value = snapshot.value as? NSDictionary
            if ((value) != nil) {
                
                var stringToAdd = "Symptom history for \(UserDefaults.standard.string(forKey: "name") ?? "") generated via Pink+ \n \n"
                
                let json = JSON(value!)
                for (key, subjson):(String, JSON) in json {
                    let _lump = subjson["Lump"].stringValue
                    let _thickness = subjson["Thickness or Swelling"].stringValue
                    let _irritatioon = subjson["Skin Irritation"].stringValue
                    let _pain = subjson["Pain or General Discomfort"].stringValue
                    let _eccentric = subjson["Eccentric Discharge"].stringValue
                    let _redness = subjson["Redness or Flaky Skin"].stringValue
                    stringToAdd = stringToAdd + "On \(key): \n Lump -> \(_lump) \n Thickness or Swelling -> \(_thickness) \n Skin Irritation -> \(_irritatioon) \n Redness or Flaky Skin -> \(_redness) \n Pain/General Discomfort -> \(_pain) \n Eccentric Drainage -> \(_eccentric) \n \n"
                }
                
                let ac = UIActivityViewController(activityItems: [stringToAdd], applicationActivities: nil)
                self.present(ac, animated: true)
            } else {
                let alert = CDAlertView(title: "Oops, something's not right!", message: "No health data to share. Please log your symptoms.", type: .error)
                let doneAction = CDAlertViewAction(title: "Sure! 💪")
                alert.add(action: doneAction)
                alert.show()
            }
          }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    
    // MARK: Symptom Buttons
    
    @IBAction func lumpButtonPressed(_ sender: Any) {
        if(lump == "No"){
            lumpButton.setTitleColor(#colorLiteral(red: 0.4673898816, green: 0.155167073, blue: 0.8269941211, alpha: 1), for: .normal)
            lump = "Yes"
        } else {
            lumpButton.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            lump = "No"
        }
    }
    
    @IBAction func thicknessButtonPressed(_ sender: Any) {
        if(thickness == "No"){
            thicknessButton.setTitleColor(#colorLiteral(red: 0.4673898816, green: 0.155167073, blue: 0.8269941211, alpha: 1), for: .normal)
            thickness = "Yes"
        } else {
            thicknessButton.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            thickness = "No"
        }
    }
    
    @IBAction func irritationButtonPressed(_ sender: Any) {
        if(irritation == "No"){
            irritationButton.setTitleColor(#colorLiteral(red: 0.4673898816, green: 0.155167073, blue: 0.8269941211, alpha: 1), for: .normal)
            irritation = "Yes"
        } else {
            irritationButton.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            irritation = "No"
        }
    }
    
    @IBAction func rednessButtonPressed(_ sender: Any) {
        if(skin == "No"){
            skinButton.setTitleColor(#colorLiteral(red: 0.4673898816, green: 0.155167073, blue: 0.8269941211, alpha: 1), for: .normal)
            skin = "Yes"
        } else {
            skinButton.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            skin = "No"
        }
    }
    
    @IBAction func painButtonPressed(_ sender: Any) {
        if(pain == "No"){
            painButton.setTitleColor(#colorLiteral(red: 0.4673898816, green: 0.155167073, blue: 0.8269941211, alpha: 1), for: .normal)
            pain = "Yes"
        } else {
            painButton.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            pain = "No"
        }
    }
    
    @IBAction func dischargeButtonPressed(_ sender: Any) {
        if(discharge == "No"){
            dischargeButton.setTitleColor(#colorLiteral(red: 0.4673898816, green: 0.155167073, blue: 0.8269941211, alpha: 1), for: .normal)
            discharge = "Yes"
        } else {
            dischargeButton.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            discharge = "No"
        }
    }
    
    @IBAction func logSymptomsButtonPressed(_ sender: Any) {
        if(lump == "No" && thickness == "No" && irritation == "No" && skin == "No" && pain == "No" && discharge == "No"){
            let alert = CDAlertView(title: "Something's missing.", message: "Please select some symptoms to be logged.", type: .error)
            let doneAction = CDAlertViewAction(title: "Okay! 😬")
            alert.add(action: doneAction)
            alert.show()
        } else {
            updateHealthData()
        }
    }
    
}
