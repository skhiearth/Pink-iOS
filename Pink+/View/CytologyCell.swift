//
//  CytologyCell.swift
//  Pink+
//
//  Created by Utkarsh Sharma on 28/09/20.
//

import UIKit

class CytologyCell: UITableViewCell {

    @IBOutlet weak var cytologyImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var mlEval: UIButton!
    @IBOutlet weak var currentResultLbl: UILabel!
    @IBOutlet weak var remarksLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}
