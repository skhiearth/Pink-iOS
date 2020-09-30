//
//  Collaborate.swift
//  Pink+
//
//  Created by Utkarsh Sharma on 26/09/20.
//

import UIKit
import SVProgressHUD
import CDAlertView
import FirebaseDatabase
import SwiftyJSON

class Collaborate: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var heightconst: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addContentBtn: UIButton!
    @IBOutlet weak var segControl: UISegmentedControl!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var scrollview: UIScrollView!
    
    var isBottomViewOpen = false
    
    var ref: DatabaseReference!
    
    var content = ""
    var tag = "Experiment"
    
    var idDict:[Int: String] = [:]
    var contentDict:[Int: String] = [:]
    var usernameDict:[Int: String] = [:]
    var tagDict:[Int: String] = [:]
    var typeDict:[Int: String] = [:]
    
    var selectedTag = ""
    var selectedUser = ""
    var selectedType = ""
    var selectedContent = ""
    var selectedId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        heightconst.constant = 350
        bottomView.layoutIfNeeded()
        addContentBtn.setTitle("Dismiss", for: .normal)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        ref = Database.database().reference()
        
        getData()
        
        setupToolbar()

        textView.placeholder = "Describe your work here..."
        
        // call the 'keyboardWillShow' function when the view controller receive the notification that a keyboard is going to be shown
            NotificationCenter.default.addObserver(self, selector: #selector(Share.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
          
              // call the 'keyboardWillHide' function when the view controlelr receive notification that keyboard is going to be hidden
            NotificationCenter.default.addObserver(self, selector: #selector(Share.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
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
        textView.inputAccessoryView = bar
    }
    
    @objc func dismissMyKeyboard(){
        view.endEditing(true)
    }
    
    func getData(){
        self.tableView.isHidden = true
        SVProgressHUD.show()
        ref.child("collab").observeSingleEvent(of: .value, with: { (snapshot) in
          let value = snapshot.value as? NSDictionary
            if ((value) != nil) {
                
                var counter = 0
                
                let json = JSON(value!)
                for (key, subjson):(String, JSON) in json {
//                        print(subsub)
                    self.idDict[counter] = key
                    self.contentDict[counter] = subjson["Content"].stringValue
                    self.usernameDict[counter] = subjson["Author"].stringValue
                    self.tagDict[counter] = subjson["Tag"].stringValue
                    self.typeDict[counter] = subjson["Type"].stringValue
                    counter = counter + 1
                }
                self.tableView.isHidden = false
                self.tableView.reloadData()
                SVProgressHUD.dismiss()
            } else {
                SVProgressHUD.dismiss()
                let alert = CDAlertView(title: "Oops, something's not right!", message: "No content to show. We'll be back with more.", type: .error)
                let doneAction = CDAlertViewAction(title: "Okay! 💪")
                alert.add(action: doneAction)
                alert.show()
            }
          }) { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
            print(error.localizedDescription)
        }
    }
    

    // MARK: IBActions
    @IBAction func changetag(_ sender: UISegmentedControl) {
        if(sender == segControl){
            switch sender.selectedSegmentIndex {
            case 0:
                tag = "Experiment"
            case 1:
                tag = "Imaging"
            case 2:
                tag = "Computing"
            case 3:
                tag = "Miscellaneous"
            default:
                tag = "Experiment"
                break;
            }
        }
    }
    
    @IBAction func addContentBtnPressed(_ sender: Any) {
        if(isBottomViewOpen){
            dismiss()
        } else{
            notdismiss()
        }
    }
    
    func notdismiss(){
        addContentBtn.setTitle("Dismiss", for: .normal)
        self.segControl.isHidden = false
        self.isBottomViewOpen = true
        self.heightconst.constant = 350
        self.scrollview.isHidden = false
        self.shareBtn.isHidden = false
        self.bottomView.layoutIfNeeded()
    }
    
    func dismiss(){
        addContentBtn.setTitle("Add new post", for: .normal)
        self.segControl.isHidden = true
        self.isBottomViewOpen = false
        self.heightconst.constant = 40
        self.scrollview.isHidden = true
        self.shareBtn.isHidden = true
        self.bottomView.layoutIfNeeded()
    }
    
    @IBAction func sharebuttonpresssed(_ sender: Any) {
        if checkValidity() {
            SVProgressHUD.show()
            
            self.shareBtn.isEnabled = false
            
            let uid = UserDefaults.standard.string(forKey: "uid")!
            let username = UserDefaults.standard.string(forKey: "name")
            let type = UserDefaults.standard.string(forKey: "type")
        
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let result = formatter.string(from: date)
        
            let uploadkey = "\(uid) on \(result)"
            
            self.ref.child("collab").child(uploadkey).setValue(["Content": self.content, "Author": username, "Tag": self.tag, "Type": type])
            dismiss()
            SVProgressHUD.dismiss()
            
            let alert = CDAlertView(title: "Thank you!", message: "Work like yours move us ahead.", type: .success)
            let doneAction = CDAlertViewAction(title: "Yay! 💪")
            alert.add(action: doneAction)
            alert.show()
            
            getData()
                    
            self.shareBtn.isEnabled = true
        }
    }
    
    func checkValidity() -> Bool {
        content = textView.text
        
        if (content == "") {
            let alert = CDAlertView(title: "Something feels wrong, Mr. Stark", message: "Please enter some content describing your work.", type: .error)
            let doneAction = CDAlertViewAction(title: "Sure! 💪")
            alert.add(action: doneAction)
            alert.show()
            return false
        } else {
            return true
        }
    }
}


//MARK: TableView
extension Collaborate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return idDict.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CollabCellTableViewCell", for: indexPath) as? CollabCellTableViewCell

        cell?.selectionStyle = .none
        
        cell?.tagLabel.text = tagDict[indexPath.row]!
        cell?.usernameLabel.text = usernameDict[indexPath.row]! + " | " + typeDict[indexPath.row]!
        cell?.contentLabel.text = contentDict[indexPath.row]!
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedTag = tagDict[indexPath.row]!
        selectedUser = usernameDict[indexPath.row]!
        selectedContent = contentDict[indexPath.row]!
        selectedId = idDict[indexPath.row]!
        selectedType = typeDict[indexPath.row]!
        
        performSegue(withIdentifier: "showCollabDetail", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCollabDetail" {
            let destinationVC = segue.destination as! CollaborateDetail
            destinationVC.tag = selectedTag
            destinationVC.author = selectedUser
            destinationVC.content = selectedContent
            destinationVC.id = selectedId
            destinationVC.type = selectedType
        }
    }
}
