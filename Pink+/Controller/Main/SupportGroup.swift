//
//  SupportGroup.swift
//  Pink+
//
//  Created by Utkarsh Sharma on 26/09/20.
//

import UIKit

class SupportGroup: UIViewController {

    @IBOutlet weak var talkwithlavel: UILabel!
    @IBOutlet weak var talkwithview: UIScrollView!
    @IBOutlet weak var talkwithstack: UIStackView!
    @IBOutlet weak var overviewCover: UIView!
    
    var selectedChatCategory = "Global"
    var type = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        overviewCover.isHidden = true

        type = UserDefaults.standard.string(forKey: "type")!

        if(type=="General Public"){
            overviewCover.isHidden = false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openChatOfType" {
            let destinationVC = segue.destination as! SupportGroupChat
            destinationVC.typeOfChat = selectedChatCategory
        }
    }
    
    // MARK: Community Buttons
    
    @IBAction func americaButton(_ sender: Any) {
        selectedChatCategory = "Americas"
        performSegue(withIdentifier: "openChatOfType", sender: nil)
    }
    
    @IBAction func africaButton(_ sender: Any) {
        selectedChatCategory = "Africa"
        performSegue(withIdentifier: "openChatOfType", sender: nil)
    }
    
    @IBAction func globalButton(_ sender: Any) {
        selectedChatCategory = "Global"
        performSegue(withIdentifier: "openChatOfType", sender: nil)
    }
    
    @IBAction func europeButton(_ sender: Any) {
        selectedChatCategory = "Europe"
        performSegue(withIdentifier: "openChatOfType", sender: nil)
    }
    
    @IBAction func apacButtoon(_ sender: Any) {
        selectedChatCategory = "APAC"
        performSegue(withIdentifier: "openChatOfType", sender: nil)
    }
    
    
    // MARK: Talk with Buttons
    
    @IBAction func survivorsButtonPressed(_ sender: Any) {
        selectedChatCategory = "Survivors"
        performSegue(withIdentifier: "openChatOfType", sender: nil)
    }
    
    @IBAction func warriorsButtonPressed(_ sender: Any) {
        selectedChatCategory = "Warriors"
        performSegue(withIdentifier: "openChatOfType", sender: nil)
    }
    
    @IBAction func openDomainButtonPressed(_ sender: Any) {
        selectedChatCategory = "Global"
        performSegue(withIdentifier: "openChatOfType", sender: nil)
    }
    
    @IBAction func medicalButtonPressed(_ sender: Any) {
        selectedChatCategory = "Medical"
        performSegue(withIdentifier: "openChatOfType", sender: nil)
    }
    
    @IBAction func researchButtonPressed(_ sender: Any) {
        selectedChatCategory = "Research"
        performSegue(withIdentifier: "openChatOfType", sender: nil)
    }
    
    
    // MARK: Community Button
    @IBAction func communityButtonPressed(_ sender: Any) {
        if(type=="Survivor"){
            selectedChatCategory = "Survivors"
            performSegue(withIdentifier: "openChatOfType", sender: nil)
        }
        
        if(type=="Medical Professional"){
            selectedChatCategory = "Medical"
            performSegue(withIdentifier: "openChatOfType", sender: nil)
        }
        
        if(type=="Research Professional"){
            selectedChatCategory = "Research"
            performSegue(withIdentifier: "openChatOfType", sender: nil)
        }
        
        
        if(type=="Patient"){
            selectedChatCategory = "Warriors"
            performSegue(withIdentifier: "openChatOfType", sender: nil)
        }
        
        if(type=="General Public"){
            selectedChatCategory = "Global"
            performSegue(withIdentifier: "openChatOfType", sender: nil)
        }
        
    }
}
