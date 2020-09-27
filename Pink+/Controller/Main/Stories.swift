//
//  Stories.swift
//  Pink+
//
//  Created by Utkarsh Sharma on 20/09/20.
//

import UIKit
import CDAlertView
import SVProgressHUD
import FirebaseDatabase
import FirebaseAuth
import SwiftyJSON
import FirebaseStorage
import Alamofire
import WatchConnectivity

class Stories: UIViewController {

    @IBOutlet weak var collabView: UIView!
    @IBOutlet weak var shareView: UIView!
    @IBOutlet weak var educateView: UIView!
    @IBOutlet weak var storiesCollectionView: UICollectionView!
    @IBOutlet weak var campaignview: UIView!
    @IBOutlet weak var healthView: UIView!
    @IBOutlet weak var doctorView: UIView!
    
    var ref: DatabaseReference!
    
    @IBOutlet weak var newsTableView: UITableView!
    var titlesDict:[Int: String] = [:]
    var storyusernameDict:[Int: String] = [:]
    var storyContentDict:[Int: String] = [:]
    var storyImagesDict:[Int: String] = [:]
    var storyImages:[Int: UIImage] = [:]
    
    var newsTitlesDict:[Int: String] = [:]
    var newsAuthorDict:[Int: String] = [:]
    var newsUrl:[Int: String] = [:]
    var newsImageDict:[Int: String] = [:]
    var newsPublishedDict:[Int: String] = [:]
    var newsImages:[Int: UIImage] = [:]
    
    var selectedTitle = ""
    var selectedUser = ""
    var selectedContent = ""
    var selectedImage: UIImage?
    
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(true)
//
//        getStories()
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        getStories()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shareView.isHidden = true
        collabView.isHidden = true
        doctorView.isHidden = true
        self.newsTableView.isHidden = true
        
        newsTableView.delegate = self
        newsTableView.dataSource = self
        
        ref = Database.database().reference()
        
        storiesCollectionView.delegate = self
        storiesCollectionView.dataSource = self

        let uid = UserDefaults.standard.string(forKey: "uid")
        let type = UserDefaults.standard.string(forKey: "type")
        
        SVProgressHUD.dismiss()
        
        getNews()
        
        
        
        if(type=="Survivor"){
            educateView.isHidden = true
            shareView.isHidden = false
        }
        
        if(type=="Medical Professional"){
            collabView.isHidden = false
            campaignview.isHidden = true
            healthView.isHidden = true
            doctorView.isHidden = false
        }
        
        if(type=="Research Professional"){
            collabView.isHidden = false
            campaignview.isHidden = true
        }
        
//        "Survivor", "Medical Professional", "Research Professional", "Patient", "General Public"
    }
    
    @IBAction func signOutBtnPressed(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "uid")
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Login") as! Login
        nextViewController.modalPresentationStyle = .fullScreen
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    func getNews() {
        let now = Date()
        let oneMonthBefore = now.adding(months: -1)!
        
        self.newsTableView.isHidden = true
        
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        let date = df.string(from: oneMonthBefore)
        
        let url : String = "http://newsapi.org/v2/everything?q=breastcancer&from=\(date)&sortBy=publishedAt&apiKey=acb1beb15863493ebbf20fc7aae5c65b"
        
        AF.request(url).responseJSON { response in
            let value = response.value as? NSDictionary
              if ((value) != nil) {
                  
                var counter = 0
                
                let json = JSON(value!)
                let status = json["status"]
                if(status == "ok"){
                    for (key, subjson):(String, JSON) in json {
                      if(key=="articles"){
                        for(key, subsub):(String, JSON) in subjson {
                            self.newsTitlesDict[counter] = subsub["title"].stringValue
                            self.newsAuthorDict[counter] = subsub["source"]["name"].stringValue
                            self.newsUrl[counter] = subsub["url"].stringValue
                            self.newsImageDict[counter] = subsub["urlToImage"].stringValue
                            
                            var date = subsub["publishedAt"].stringValue
                            if let dotRange = date.range(of: "T") {
                                date.removeSubrange(dotRange.lowerBound..<date.endIndex)
                            }
                            
                            self.newsPublishedDict[counter] = date
                            counter = counter + 1
                        }
                      }
                    }
                    
                    self.newsTableView.isHidden = false
                    self.newsTableView.reloadData()
                } else {
                    let alert = CDAlertView(title: "Oops, something's not right!", message: "No news to show. We'll be back with more.", type: .error)
                    let doneAction = CDAlertViewAction(title: "Sure! 💪")
                    alert.add(action: doneAction)
                    alert.show()
                }
              }
        }
    }
    
}


extension Stories: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titlesDict.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = storiesCollectionView.dequeueReusableCell(withReuseIdentifier: "story", for: indexPath) as? StoryCell
        cell?.title.text = titlesDict[indexPath.row]
        cell?.usernameLabel.text = "by " + storyusernameDict[indexPath.row]!
        
        self.storyImages[indexPath.row] = UIImage(named: "storyDef")
        cell?.storyImgView.image = UIImage(named: "storyDef")
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let spaceRef = storageRef.child("uploads/\(storyusernameDict[indexPath.row]!).png")

        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        spaceRef.getData(maxSize: 2 * 1024 * 1024) { data, error in
          if let error = error {
            print(error)
          } else {
            cell?.storyImgView.image = UIImage(data: data!)
            self.storyImages[indexPath.row] = UIImage(data: data!)
          }
        }
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedTitle = titlesDict[indexPath.row]!
        selectedUser = storyusernameDict[indexPath.row]!
        selectedContent = storyContentDict[indexPath.row]!
        selectedImage = storyImages[indexPath.row]!
        
        performSegue(withIdentifier: "showOneStory", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showOneStory" {
            
            var cheer = false
            
            ref.child("storyLikes").child(selectedTitle).observeSingleEvent(of: .value, with: { (snapshot) in
              let value = snapshot.value as? NSDictionary
                if ((value) != nil) {
                    
                    let json = JSON(value!)
                    for (key, subjson):(String, JSON) in json {
                        if(key == UserDefaults.standard.string(forKey: "uid")){
                            cheer = true
                        }
                    }
                }
              }) { (error) in
                SVProgressHUD.showError(withStatus: error.localizedDescription)
                print(error.localizedDescription)
            }
            
            let destinationVC = segue.destination as! Story
            destinationVC.titleOfStory = selectedTitle
            destinationVC.author = selectedUser
            destinationVC.content = selectedContent
            destinationVC.storyimage = selectedImage
            
            if cheer {
                destinationVC.cheer = true
            } else {
                destinationVC.cheer = false
            }
        }
    }
    
    func getStories(){
        ref.child("stories").observeSingleEvent(of: .value, with: { (snapshot) in
          let value = snapshot.value as? NSDictionary
            if ((value) != nil) {
                
//                var stringToAdd = "Symptom history for \(UserDefaults.standard.string(forKey: "name") ?? "") generated via Pink+ \n \n"
                
                var counter = 0
                
                let json = JSON(value!)
                for (key, subjson):(String, JSON) in json {
                    for (key, subsub):(String, JSON) in subjson {
//                        print(subsub)
                        self.titlesDict[counter] = key
                        self.storyusernameDict[counter] = subsub["Author"].stringValue
                        self.storyContentDict[counter] = subsub["Content"].stringValue
                        self.storyImagesDict[counter] = subsub["Image"].stringValue
                        counter = counter + 1
                    }
                }
                print(self.titlesDict.count)
                self.storiesCollectionView.reloadData()
            } else {
                let alert = CDAlertView(title: "Oops, something's not right!", message: "No stories to show. We'll be back with more.", type: .error)
                let doneAction = CDAlertViewAction(title: "Sure! 💪")
                alert.add(action: doneAction)
                alert.show()
            }
          }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    
}


extension Stories: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsTitlesDict.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as? NewsCell
        
        cell?.selectionStyle = .none
        
        cell?.titleOfNews.text = newsTitlesDict[indexPath.row]
        cell?.publisher.text = newsAuthorDict[indexPath.row]!
        cell?.datePublished.text = newsPublishedDict[indexPath.row]!
        
        self.newsImages[indexPath.row] = UIImage(named: "educateDef")
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print(newsUrl[indexPath.row])
        
        if let url = URL(string: newsUrl[indexPath.row]!) {
            UIApplication.shared.open(url)
        } else {
            let alert = CDAlertView(title: "Oops, something's not right!", message: "Can't open this news article. Please try again later.", type: .error)
            let doneAction = CDAlertViewAction(title: "Okay! 💪")
            alert.add(action: doneAction)
            alert.show()
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }
}

