//
//  Launch.swift
//  Pink+
//
//  Created by Utkarsh Sharma on 20/09/20.
//

import UIKit
import RevealingSplashView
import FirebaseAuth
import FirebaseDatabase
import SVProgressHUD
import SwiftyJSON
import NVActivityIndicatorView

class Launch: UIViewController {
    
    var ref: DatabaseReference!
    var titlesDict:[Int: String] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()

        super.viewDidLoad()
        
        ref = Database.database().reference()

        //Initialize a revealing Splash with with the iconImage, the initial size and the background color
        let revealingSplashView = RevealingSplashView(iconImage: UIImage(named: "roseIcon")!,iconInitialSize: CGSize(width: 108, height: 108), backgroundColor: #colorLiteral(red: 1, green: 0.5764705882, blue: 0.5764705882, alpha: 0.9))

        //Adds the revealing splash view as a sub view
        self.view.addSubview(revealingSplashView)

        //Starts animation
        revealingSplashView.startAnimation(){
            SVProgressHUD.show(withStatus: "Setting up a few things...")
            revealingSplashView.heartAttack = true
            
            let uid = UserDefaults.standard.string(forKey: "uid")
            if (uid != nil){
                
                UserDefaults.standard.set(uid, forKey: "")
                
                self.ref.child("users").child(uid!).observeSingleEvent(of: .value, with: { [self] (snapshot) in
                    
                  let value = snapshot.value as! NSDictionary
                    
                    // Progress
                    SVProgressHUD.show(withStatus: "Setting up a few things...")

                    
                    UserDefaults.standard.set(uid, forKey: "uid")
                    
                    let name = value["Name"] as! String
                    UserDefaults.standard.set(name, forKey: "name")
                    
                    let type = value["Type"] as! String
                    UserDefaults.standard.set(type, forKey: "type")
                    
                    let gender = value["Gender"] as! String
                    UserDefaults.standard.set(gender, forKey: "gender")
                    
                    let email = value["Email"] as! String
                    UserDefaults.standard.set(email, forKey: "email")
                    
                    let country = value["Country"] as! String
                    UserDefaults.standard.set(country, forKey: "country")
                    
                    let age = value["Age"] as! String
                    UserDefaults.standard.set(age, forKey: "age")
                    
                    if(uid != ""){
                        
                        self.ref.child("stories").observeSingleEvent(of: .value, with: { (snapshot) in
                          let value = snapshot.value as? NSDictionary
                                
                            self.showMain()

                            print(self.titlesDict.count)
                          }) { (error) in
                            print(error.localizedDescription)
                        }
                    }
                  }) { (error) in
                    print(error.localizedDescription)
                }
                
            } else {
                self.showAuth()
            }
            
        }
    }
    
    
    func showMain() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Pink", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Stories") as! Stories
        nextViewController.modalPresentationStyle = .fullScreen
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            SVProgressHUD.dismiss()
            self.present(nextViewController, animated:true, completion:nil)
        })
    }
    
    func showAuth() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "GetStarted") as! GetStarted
        nextViewController.modalPresentationStyle = .fullScreen
        self.present(nextViewController, animated:true, completion:nil)
    }
    

}
