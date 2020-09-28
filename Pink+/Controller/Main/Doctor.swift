//
//  Doctor.swift
//  Pink+
//
//  Created by Utkarsh Sharma on 27/09/20.
//

import UIKit
import FirebaseDatabase
import CDAlertView
import SVProgressHUD
import Alamofire
import SwiftyJSON
import FirebaseStorage

class Doctor: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var symptomButton: UIButton!
    
    var cytologyNameDict:[Int: String] = [:]
    var cytologyAgeDict:[Int: String] = [:]
    var cytologyImages:[Int: UIImage] = [:]
    
    var selectedName = ""
    var selectedAge = ""
    var selectedImage: UIImage?
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        getCytology()
        
        tableView.delegate = self
        tableView.dataSource = self
    }

    @IBAction func symptomButtonPressed(_ sender: Any) {
        
    }
    
}


extension Doctor {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cytologyNameDict.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CytologyCell", for: indexPath) as? CytologyCell

        cell?.selectionStyle = .none
        
        cell?.nameLabel.text = cytologyNameDict[indexPath.row]
        cell?.ageLabel.text = "Age: \(cytologyAgeDict[indexPath.row]!)"
        cell?.cytologyImage.image = UIImage(named: "educateDef")
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let spaceRef = storageRef.child("uploads/\(cytologyNameDict[indexPath.row]!)cytology.png")

        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        spaceRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
          if let error = error {
                print(error)
          } else {
                self.cytologyImages[indexPath.row] = UIImage(data: data!)
                cell?.cytologyImage.image = self.cytologyImages[indexPath.row]
          }
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedName = cytologyNameDict[indexPath.row]!
        selectedAge = cytologyAgeDict[indexPath.row]!
        selectedImage = cytologyImages[indexPath.row]!
    }
    
    func getCytology(){
        self.tableView.isHidden = true
        SVProgressHUD.show()
        
        self.cytologyNameDict.removeAll()
        self.cytologyAgeDict.removeAll()
        
        var counter = 0
        ref.child("cytologyreports").observeSingleEvent(of: .value, with: { (snapshot) in
          let value = snapshot.value as? NSDictionary
            if ((value) != nil) {
                
                let json = JSON(value!)
                counter = 0
                for (key, subjson):(String, JSON) in json {
                    self.cytologyNameDict[counter] = key
                    self.cytologyAgeDict[counter] = subjson["Age"].stringValue
                    counter = counter + 1
                    
                    self.tableView.isHidden = false
                    SVProgressHUD.dismiss()
                }
                
                if(self.cytologyNameDict.count == 0){
                    SVProgressHUD.dismiss()
                    let alert = CDAlertView(title: "Oops, something's not right!", message: "No cytology reports to show. Please try again later.", type: .error)
                    let doneAction = CDAlertViewAction(title: "Sure! 💪")
                    alert.add(action: doneAction)
                    alert.show()
                } else {
                    self.tableView.reloadData()
                }
            } else {
                SVProgressHUD.dismiss()
                let alert = CDAlertView(title: "Oops, something's not right!", message: "No reports to show. Please try again later", type: .error)
                let doneAction = CDAlertViewAction(title: "Sure! 💪")
                alert.add(action: doneAction)
                alert.show()
            }
          }) { (error) in
            SVProgressHUD.dismiss()
            print(error.localizedDescription)
        }
    }
}
