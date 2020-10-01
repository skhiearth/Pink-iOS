//
//  EducateViewController.swift
//  Pink+
//
//  Created by Utkarsh Sharma on 27/09/20.
//

import UIKit
import CDAlertView
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth
import SVProgressHUD
import SwiftyJSON

class EducateViewController: UIViewController {

    @IBOutlet weak var uploadButtonView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var titlesDict:[Int: String] = [:]
    var educateusernameDict:[Int: String] = [:]
    var educateContentDict:[Int: String] = [:]
    var educateTypeDict:[Int: String] = [:]
    var educateCategoryDict:[Int: String] = [:]
    var educateImagesDict:[Int: String] = [:]
    var educateImages:[Int: UIImage] = [:]
    
    var selectedTitle = ""
    var selectedUser = ""
    var selectedContent = ""
    var selectedType = ""
    var selectedImage: UIImage?
    
    var ref: DatabaseReference!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        getEducate(category: "General")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()

        uploadButtonView.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
        
        let type = UserDefaults.standard.string(forKey: "type")
        
        if(type=="Medical Professional"){
            uploadButtonView.isHidden = false
        }
//        "Survivor", "Medical Professional", "Research Professional", "Patient", "General Public"
    }

    
    @IBAction func filterContent(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.getEducate(category: "Overview")
        case 1:
            self.getEducate(category: "Detection")
        case 2:
            self.getEducate(category: "Diagnosis")
        case 3:
            self.getEducate(category: "Prognosis")
        case 4:
            self.getEducate(category: "Myths")
        default:
            self.getEducate(category: "Overview")
            break;
        }
    }
    
    @IBAction func uploadButtonPressed(_ sender: Any) {
        
    }
}

extension EducateViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titlesDict.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EducateCell", for: indexPath) as? EducateCell

        cell?.selectionStyle = .none
        
        cell?.typeLabel.text = ""
        
        cell?.titleLabel.text = titlesDict[indexPath.row]
        cell?.usernameLabel.text = "by @" + educateusernameDict[indexPath.row]!
        cell?.typeLabel.text = educateTypeDict[indexPath.row]!
        
        self.educateImages[indexPath.row] = UIImage(named: "educateDef")
        
        if(educateTypeDict[indexPath.row]! == "Blog"){
            self.educateImages[indexPath.row] = UIImage(named: "educateDef")
        }else{
            let storage = Storage.storage()
            let storageRef = storage.reference()
            let spaceRef = storageRef.child("uploads/\(educateusernameDict[indexPath.row]!)educate.png")

            // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
            spaceRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
              if let error = error {
                print(error)
              } else {
                self.educateImages[indexPath.row] = UIImage(data: data!)
              }
            }
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedTitle = titlesDict[indexPath.row]!
        selectedUser = educateusernameDict[indexPath.row]!
        selectedContent = educateContentDict[indexPath.row]!
        selectedImage = educateImages[indexPath.row]!
        selectedType = educateTypeDict[indexPath.row]!
        
        performSegue(withIdentifier: "showEducateContentInDetail", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showEducateContentInDetail" {
            
            let destinationVC = segue.destination as! EducateDetail
            destinationVC.titleOfEducate = selectedTitle
            destinationVC.author = selectedUser
            destinationVC.content = selectedContent
            destinationVC.educateImage = selectedImage
            destinationVC.type = selectedType
        }
    }
    
    
    func getEducate(category: String){
        self.tableView.isHidden = true
        SVProgressHUD.show()
        
        self.educateusernameDict.removeAll()
        self.educateContentDict.removeAll()
        self.educateTypeDict.removeAll()
        self.educateCategoryDict.removeAll()
        self.educateImagesDict.removeAll()
        
        var counter = 0
        ref.child("content").observeSingleEvent(of: .value, with: { (snapshot) in
          let value = snapshot.value as? NSDictionary
            if ((value) != nil) {
                
                let json = JSON(value!)
                counter = 0
                for (key, subjson):(String, JSON) in json {
                    for (key, subsub):(String, JSON) in subjson {
                        if(subsub["Cat"].stringValue == category) {
                            
                            self.titlesDict[counter] = key
                            self.educateusernameDict[counter] = subsub["Author"].stringValue
                            self.educateContentDict[counter] = subsub["Content"].stringValue
                            self.educateTypeDict[counter] = subsub["Type"].stringValue
                            self.educateCategoryDict[counter] = subsub["Cat"].stringValue
                            self.educateImagesDict[counter] = subsub["Media"].stringValue
                            counter = counter + 1
                            
                            self.tableView.isHidden = false
                            SVProgressHUD.dismiss()
                        }
                    }
                }
                
                if(self.educateCategoryDict.count == 0){
                    SVProgressHUD.dismiss()
                    let alert = CDAlertView(title: "Oops, something's not right!", message: "No \(category) content to show. We'll be back with more. In the meantime, please check our other category offerings.", type: .error)
                    let doneAction = CDAlertViewAction(title: "Sure! 💪")
                    alert.add(action: doneAction)
                    alert.show()
                } else {
                    self.tableView.reloadData()
                }
            } else {
                SVProgressHUD.dismiss()
                let alert = CDAlertView(title: "Oops, something's not right!", message: "No educational content to show. We'll be back with more.", type: .error)
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
