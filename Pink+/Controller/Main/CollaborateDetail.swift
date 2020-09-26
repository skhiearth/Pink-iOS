//
//  CollaborateDetail.swift
//  Pink+
//
//  Created by Utkarsh Sharma on 26/09/20.
//

import UIKit

class CollaborateDetail: UIViewController {

    var tag = ""
    var author = ""
    var type = ""
    var content = ""
    var id = ""
    
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        typeLabel.text = tag
        usernameLabel.text = "by " + author + " | " + type
        contentLabel.text = content
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCollabChat" {
            let destinationVC = segue.destination as! CollabChat
            destinationVC.idOfChat = id
        }
    }

    @IBAction func openDiscussionPanel(_ sender: Any) {
        // showCollabChat
        performSegue(withIdentifier: "showCollabChat", sender: nil)
    }
}
