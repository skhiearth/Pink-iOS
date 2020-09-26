//
//  NewsCell.swift
//  Pink+
//
//  Created by Utkarsh Sharma on 24/09/20.
//

import UIKit

class NewsCell: UITableViewCell {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var datePublished: UILabel!
    @IBOutlet weak var publisher: UILabel!
    @IBOutlet weak var titleOfNews: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
