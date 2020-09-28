//
//  Campaigns.swift
//  Pink+
//
//  Created by Utkarsh Sharma on 23/09/20.
//

import UIKit
import CDAlertView

class Campaigns: UIViewController, UIActionSheetDelegate {

    @IBOutlet weak var dismissTopView: UIView!
    @IBOutlet weak var dismissBottomView: UIView!
    @IBOutlet weak var contentLabel: UILabel!
    
    var selectedCampaign = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dismissTopView.isHidden = true
        dismissBottomView.isHidden = true
    }

    @IBAction func socialMediaButtonPressed(_ sender: Any) {
        dismissTopView.isHidden = false
        dismissBottomView.isHidden = false
        contentLabel.text = socialMedia
        selectedCampaign = "socialMedia"
    }
    
    @IBAction func streamingButtonPressed(_ sender: Any) {
        dismissTopView.isHidden = false
        dismissBottomView.isHidden = false
        contentLabel.text = onlineStreaming
        selectedCampaign = "onlineStreaming"
    }
    
    @IBAction func onlineClassesButtonPressed(_ sender: Any) {
        dismissTopView.isHidden = false
        dismissBottomView.isHidden = false
        contentLabel.text = onlineClasses
        selectedCampaign = "onlineClasses"
    }
    
    @IBAction func newsletterButtonPressed(_ sender: Any) {
        dismissTopView.isHidden = false
        dismissBottomView.isHidden = false
        contentLabel.text = printMedia
        selectedCampaign = "printMedia"
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismissTopView.isHidden = true
        dismissBottomView.isHidden = true
    }
    
    @IBAction func dismissButtonPressed(_ sender: Any) {
        dismissTopView.isHidden = true
        dismissBottomView.isHidden = true
    }
    
    @IBAction func joinButtonPressed(_ sender: Any) {
        if(selectedCampaign == "onlineStreaming"){
            showYTActionSheet(controller: self)
        } else if(selectedCampaign == "printMedia"){
            
        } else if(selectedCampaign == "onlineClasses"){
            showonlineClassesActionSheet(controller: self)
        } else if(selectedCampaign == "socialMedia"){
            showSocialActionSheet(controller: self)
        } else {
            let alert = CDAlertView(title: "Oops, something's not right!", message: "Can't open this image. Please try again later.", type: .error)
            let doneAction = CDAlertViewAction(title: "Okay! 💪")
            alert.add(action: doneAction)
            alert.show()
        }
    }
    
    @IBAction func showLoveButton(_ sender: Any) {
        let alert = UIAlertController(title: "Instagram Filter", message: "Pink+ is proud to offer you an Instagram filter to proudly showcase the pink ribbon in front of all your followers.", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Open Instagram", style: .default, handler: { (_) in
            if let url = URL(string: "https://www.instagram.com/ar/326563375244955/") {
                UIApplication.shared.open(url)
            } else {
                let alert = CDAlertView(title: "Oops, something's not right!", message: "Can't open this image. Please try again later.", type: .error)
                let doneAction = CDAlertViewAction(title: "Okay! 💪")
                alert.add(action: doneAction)
                alert.show()
            }
        }))

        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { (_) in
            print("User click Dismiss button")
        }))

        self.present(alert, animated: true, completion: {
            print("Completion block")
        })
    }
    
    func showYTActionSheet(controller: UIViewController) {
        let alert = UIAlertController(title: "Online Streaming Campaigns", message: "Pink+ is proud to offer you a free channel art template to reflect your support with the Breast Cancer campaign.", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Download", style: .default, handler: { (_) in
            if let url = URL(string: "https://ibb.co/ynTRqLy") {
                UIApplication.shared.open(url)
            } else {
                let alert = CDAlertView(title: "Oops, something's not right!", message: "Can't open this image. Please try again later.", type: .error)
                let doneAction = CDAlertViewAction(title: "Okay! 💪")
                alert.add(action: doneAction)
                alert.show()
            }
        }))

        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { (_) in
            print("User click Dismiss button")
        }))

        self.present(alert, animated: true, completion: {
            print("Completion block")
        })
    }
    
    func showSocialActionSheet(controller: UIViewController) {
        let alert = UIAlertController(title: "Social Media Campaigns", message: "Pink+ is happy to offer you a bunch of story templates for Instagram and WhatsApp that you can use to reflect your association with the movement. You can download one according to your device preference.", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "iPhone 6/6S/7/SE 2", style: .default, handler: { (_) in
            if let url = URL(string: "https://ibb.co/gvGWykC") {
                UIApplication.shared.open(url)
            } else {
                let alert = CDAlertView(title: "Oops, something's not right!", message: "Can't open this image. Please try again later.", type: .error)
                let doneAction = CDAlertViewAction(title: "Okay! 💪")
                alert.add(action: doneAction)
                alert.show()
            }
        }))
        
        alert.addAction(UIAlertAction(title: "iPhone 7 Plus/8 Plus", style: .default, handler: { (_) in
            if let url = URL(string: "https://ibb.co/bdS4p9j") {
                UIApplication.shared.open(url)
            } else {
                let alert = CDAlertView(title: "Oops, something's not right!", message: "Can't open this image. Please try again later.", type: .error)
                let doneAction = CDAlertViewAction(title: "Okay! 💪")
                alert.add(action: doneAction)
                alert.show()
            }
        }))
        
        alert.addAction(UIAlertAction(title: "iPhone 11 Pro Max", style: .default, handler: { (_) in
            if let url = URL(string: "https://ibb.co/fGGZGYR") {
                UIApplication.shared.open(url)
            } else {
                let alert = CDAlertView(title: "Oops, something's not right!", message: "Can't open this image. Please try again later.", type: .error)
                let doneAction = CDAlertViewAction(title: "Okay! 💪")
                alert.add(action: doneAction)
                alert.show()
            }
        }))
        
        alert.addAction(UIAlertAction(title: "iPhone X/XS/11 Pro/Others", style: .default, handler: { (_) in
            if let url = URL(string: "https://ibb.co/sJyysr6") {
                UIApplication.shared.open(url)
            } else {
                let alert = CDAlertView(title: "Oops, something's not right!", message: "Can't open this image. Please try again later.", type: .error)
                let doneAction = CDAlertViewAction(title: "Okay! 💪")
                alert.add(action: doneAction)
                alert.show()
            }
        }))
        
        alert.addAction(UIAlertAction(title: "iPhone XR/11", style: .default, handler: { (_) in
            if let url = URL(string: "https://ibb.co/st2rh3g") {
                UIApplication.shared.open(url)
            } else {
                let alert = CDAlertView(title: "Oops, something's not right!", message: "Can't open this image. Please try again later.", type: .error)
                let doneAction = CDAlertViewAction(title: "Okay! 💪")
                alert.add(action: doneAction)
                alert.show()
            }
        }))

        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { (_) in
            print("User click Dismiss button")
        }))

        self.present(alert, animated: true, completion: {
            print("Completion block")
        })
    }
    
    func showonlineClassesActionSheet(controller: UIViewController) {
        let alert = UIAlertController(title: "Online Classes Campaigns", message: "Pink+ is proud to offer you a free background image to reflect your support with the Breast Cancer campaign. You can use this as your Zoom background, as a wallpaper, or however you wish.", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Download", style: .default, handler: { (_) in
            if let url = URL(string: "https://ibb.co/XyvdXMQ") {
                UIApplication.shared.open(url)
            } else {
                let alert = CDAlertView(title: "Oops, something's not right!", message: "Can't open this image. Please try again later.", type: .error)
                let doneAction = CDAlertViewAction(title: "Okay! 💪")
                alert.add(action: doneAction)
                alert.show()
            }
        }))

        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { (_) in
            print("User click Dismiss button")
        }))

        self.present(alert, animated: true, completion: {
            print("Completion block")
        })
    }
    
}
