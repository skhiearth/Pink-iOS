//
//  GailViewController.swift
//  Pink+
//
//  Created by Utkarsh Sharma on 24/09/20.
//

import UIKit
import CDAlertView
import FirebaseDatabase

class GailViewController: UIViewController {

    @IBOutlet weak var menstrualControl: UISegmentedControl!
    @IBOutlet weak var biopsyControl: UISegmentedControl!
    @IBOutlet weak var birthControl: UISegmentedControl!
    @IBOutlet weak var relativeControl: UISegmentedControl!
    
    var agemen = 0
    var agecat = 0
    var nbiops = 0
    var ageflb = 0
    var numrel = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let age = Int(UserDefaults.standard.string(forKey: "age")!)!
        
        if(age < 50){
            agecat = 0
        } else {
            agecat = 1
        }
        
        print(String(gailModel(agemen: 1, agecat: 1, nbiops: 1, ageflb: 1, numrel: 2)))
    }
    
    
    // MARK: SegmentedControl Actions
    @IBAction func mensChange(_ sender: UISegmentedControl) {
        if(sender == menstrualControl){
            switch sender.selectedSegmentIndex {
            case 0:
                agemen = 2
            case 1:
                agemen = 1
            case 2:
                agemen = 0
            default:
                agemen = 2
                break;
            }
        }
    }
    
    @IBAction func biopsyChange(_ sender: UISegmentedControl) {
        if(sender == biopsyControl){
            switch sender.selectedSegmentIndex {
            case 0:
                nbiops = 0
            case 1:
                nbiops = 1
            case 2:
                nbiops = 2
            default:
                nbiops = 0
                break;
            }
        }
    }
    
    @IBAction func birthChange(_ sender: UISegmentedControl) {
        if(sender == birthControl){
            switch sender.selectedSegmentIndex {
            case 0:
                ageflb = 0
            case 1:
                ageflb = 1
            case 2:
                ageflb = 2
            case 3:
                ageflb = 3
            case 4:
                ageflb = 2
            default:
                ageflb = 0
                break;
            }
        }
    }
    
    @IBAction func relativecontrol(_ sender: UISegmentedControl) {
        if(sender == relativeControl){
            switch sender.selectedSegmentIndex {
            case 0:
                numrel = 0
            case 1:
                numrel = 1
            case 2:
                numrel = 2
            default:
                numrel = 0
                break;
            }
        }
    }
    
    
    @IBAction func evaluatebtnpressed(_ sender: Any) {
        let risk = String(gailModel(agemen: agemen, agecat: agecat, nbiops: nbiops, ageflb: ageflb, numrel: numrel))
        let mess = "Your relative risk for breast cancer is " + risk + "%, compared to an individual of the same age without any risk factors."
        let alert = CDAlertView(title: "GAIL Risk Evaluation", message: mess, type: .notification)
        let doneAction = CDAlertViewAction(title: "Okay! 🤙")
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        alert.add(action: doneAction)
        alert.show()
        DispatchQueue.main.asyncAfter(deadline:.now() + 2.0, execute: {
            self.dismiss(animated: true, completion: nil)
        })
        
    }
}
