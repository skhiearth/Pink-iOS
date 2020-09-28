//
//  Story.swift
//  Pink+
//
//  Created by Utkarsh Sharma on 24/09/20.
//

import UIKit
import CDAlertView
import FirebaseDatabase
import SwiftyJSON
import SVProgressHUD

class Story: UIViewController {
    
    var titleOfStory = ""
    var author = ""
    var content = ""
    var storyimage: UIImage?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var cheerButton: UIButton!
    @IBOutlet weak var supportImage: UIImageView!
    @IBOutlet weak var supportedImage: UIImageView!
    
    var cheer = true
    
    var ref: DatabaseReference!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.supportImage.isHidden = true
        
        imageHandling()
        checkLikes()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.supportImage.isHidden = true
        
        ref = Database.database().reference()
        
        titleLabel.text = titleOfStory
        usernameLabel.text = "by @" + author
        contentLabel.text = content
        backgroundImage.image = storyimage
    }
    
    
    func imageHandling(){
        if cheer {
            supportImage.isHidden = true
            supportedImage.isHidden = false
        } else {
            supportImage.isHidden = false
            supportedImage.isHidden = true
        }
    }
    
    func checkLikes(){
        
        ref.child("storyLikes").child(titleOfStory).observeSingleEvent(of: .value, with: { (snapshot) in
          let value = snapshot.value as? NSDictionary
            if ((value) != nil) {
                
                let json = JSON(value!)
                for (key, subjson):(String, JSON) in json {
                    print(key)
                    if(key == UserDefaults.standard.string(forKey: "uid")){
                        self.cheer = true
                        self.imageHandling()
                    }
                }
            }
          }) { (error) in
            SVProgressHUD.dismiss()
            SVProgressHUD.showError(withStatus: error.localizedDescription)
            print(error.localizedDescription)
        }
    }

    
    //MARK: IBActions
    @IBAction func supportButtonPressed(_ sender: Any) {
        self.ref.child("storyLikes").child(titleOfStory).child(UserDefaults.standard.string(forKey: "uid")!).setValue(["support": "yes"])
        
        let alert = CDAlertView(title: "Thanks for the support!", message: "We're glad you liked this story.", type: .success)
        let doneAction = CDAlertViewAction(title: "Sure! 💪")
        alert.add(action: doneAction)
        alert.show()
        
        checkLikes()
        imageHandling()
    }
}
