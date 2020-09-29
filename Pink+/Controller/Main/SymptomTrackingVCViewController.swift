//
//  SymptomTrackingVCViewController.swift
//  Pink+
//
//  Created by Utkarsh Sharma on 29/09/20.
//

import UIKit
import FirebaseDatabase
import CDAlertView
import SVProgressHUD
import SwiftyJSON
import Alamofire

class SymptomTrackingVCViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var idDict:[Int: String] = [:]
    var logsDict:[Int: String] = [:]
    
    var selectedId = ""
    var selectedLog = ""
    
    var ref: DatabaseReference!
    
    var remarkField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        getData()

        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func getData(){
        self.tableView.isHidden = true
        SVProgressHUD.show()
        ref.child("healthData").observeSingleEvent(of: .value, with: { (snapshot) in
          let value = snapshot.value as? NSDictionary
            if ((value) != nil) {
                
                var counter = 0
                
                let json = JSON(value!)
                for (key, subjson):(String, JSON) in json {
                    var stringToAdd = "Symptom history for \(key) generated via Pink+ \n \n"
                    for(key, subsub):(String, JSON) in subjson{
                        let _lump = subsub["Lump"].stringValue
                        let _thickness = subsub["Thickness or Swelling"].stringValue
                        let _irritatioon = subsub["Skin Irritation"].stringValue
                        let _pain = subsub["Pain or General Discomfort"].stringValue
                        let _eccentric = subsub["Eccentric Discharge"].stringValue
                        let _redness = subsub["Redness or Flaky Skin"].stringValue
                        stringToAdd = stringToAdd + "On \(key): \n Lump -> \(_lump) \n Thickness or Swelling -> \(_thickness) \n Skin Irritation -> \(_irritatioon) \n Redness or Flaky Skin -> \(_redness) \n Pain/General Discomfort -> \(_pain) \n Eccentric Drainage -> \(_eccentric) \n \n"
                    }
                    counter = counter + 1
                    self.idDict[counter] = key
                    self.logsDict[counter] = stringToAdd
                }
                
                self.tableView.isHidden = false
                self.tableView.reloadData()
            } else {
                let alert = CDAlertView(title: "Oops, something's not right!", message: "No health data to share.", type: .error)
                let doneAction = CDAlertViewAction(title: "Sure! 💪")
                alert.add(action: doneAction)
                alert.show()
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            }
          }) { (error) in
            print(error.localizedDescription)
        }
    }
}


extension SymptomTrackingVCViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.idDict.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SymptomCell", for: indexPath) as? SymptomCell

        cell?.selectionStyle = .none
        
        cell?.idLabel.text = idDict[indexPath.row + 1]
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedId = idDict[indexPath.row + 1]!
        selectedLog = logsDict[indexPath.row + 1]!
        
        self.displayForm(message: selectedLog)
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
    
    
    func displayForm(message:String){
            //create alert
            let alert = UIAlertController(title: "Symptom Log", message: message, preferredStyle: .alert)
            
            //create cancel button
            let cancelAction = UIAlertAction(title: "Cancel" , style: .cancel)
            
            //create save button
            let saveAction = UIAlertAction(title: "Submit", style: .default) { (action) -> Void in
               //validation logic goes here
                if((self.remarkField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)!){
                    self.remarkField.text = ""
                    
                    self.displayForm(message: "One of the values entered was invalid. Please enter all information")
                }
                
                let remarks: String! = self.remarkField.text!

                let stringToPass = "\(remarks ?? "")"
                
                print(stringToPass)
                
                SVProgressHUD.show(withStatus: "Submitting....")
                
                // Submit here to database
                self.ref.child("symptomremarks").child(self.selectedId).setValue(["Remark": stringToPass])
                SVProgressHUD.dismiss()
            }
            
            //add button to alert
            alert.addAction(cancelAction)
            alert.addAction(saveAction)
            
            alert.addTextField(configurationHandler: {(textField: UITextField!) in
                textField.placeholder = "Your remarks here"
                textField.keyboardType = .default
                self.remarkField = textField
            })
        
            self.present(alert, animated: true, completion: nil)
    }
}
