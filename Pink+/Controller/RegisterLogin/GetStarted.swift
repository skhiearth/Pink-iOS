//
//  GetStarted.swift
//  Pink+
//
//  Created by Utkarsh Sharma on 28/09/20.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import SVProgressHUD

class GetStarted: UIViewController {
    
    //MARK: IBOutlets

    override func viewDidLoad() {
        super.viewDidLoad()
            
        SVProgressHUD.dismiss()
    }
    
    // MARK: IBAction
    @IBAction func getStartedButtonTapped(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "RegisterOne") as! RegisterOne
        self.present(nextViewController, animated:true, completion:nil)
    }
    
}
