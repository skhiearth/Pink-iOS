//
//  EducateDetail.swift
//  Pink+
//
//  Created by Utkarsh Sharma on 25/09/20.
//

import UIKit

class EducateDetail: UIViewController {
    
    var titleOfEducate = ""
    var author = ""
    var content = ""
    var type = ""
    var educateImage: UIImage?

    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var buttonView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentLabel.text = content
        usernameLabel.text = author
        titleLabel.text = titleOfEducate

        if (type == "Blog"){
            buttonView.isHidden = true
        }
    }
    
    @IBAction func showMediaButtonPressed(_ sender: Any) {
        
    }
    
}
