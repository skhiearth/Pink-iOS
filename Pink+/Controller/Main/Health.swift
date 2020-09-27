//
//  Health.swift
//  Pink+
//
//  Created by Utkarsh Sharma on 20/09/20.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import CDAlertView
import SwiftyJSON
import WatchConnectivity

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
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()

        userLabel.text = "Hi, \(UserDefaults.standard.string(forKey: "name") ?? "")"
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
