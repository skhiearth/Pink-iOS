//
//  SymptomTracking.swift
//  Pink+ Tracker Extension
//
//  Created by Utkarsh Sharma on 27/09/20.
//

import UIKit
import WatchKit
import WatchConnectivity

class SymptomTracking: WKInterfaceController {
    @IBOutlet weak var symptomLoggingLabel: WKInterfaceLabel!
    @IBOutlet weak var lumpSwitch: WKInterfaceSwitch!
    @IBOutlet weak var thicknessSwitch: WKInterfaceSwitch!
    @IBOutlet weak var irritationSwift: WKInterfaceSwitch!
    @IBOutlet weak var skinSwitch: WKInterfaceSwitch!
    @IBOutlet weak var painSwitch: WKInterfaceSwitch!
    @IBOutlet weak var dischargeSwitch: WKInterfaceSwitch!
    @IBOutlet weak var logSymptomButton: WKInterfaceButton!
    
    let session = WCSession.default
    
    var lump = "No"
    var thickness = "No"
    var irritation = "No"
    var skin = "No"
    var pain = "No"
    var discharge = "No"
    
    override func awake(withContext context: Any?) {
      super.awake(withContext: context)
        session.delegate = self
        session.activate()
    }
    
    @IBAction func lumpSwitcher(_ value: Bool) {
        if(lump=="No"){
            lump="Yes"
        } else{
            lump="No"
        }
    }
    
    @IBAction func swellingSwitcher(_ value: Bool) {
        if(thickness=="No"){
            thickness="Yes"
        } else{
            thickness="No"
        }
    }
    
    @IBAction func irritationSwitcher(_ value: Bool) {
        if(irritation=="No"){
            irritation="Yes"
        } else{
            irritation="No"
        }
    }
    
    @IBAction func skinswitcher(_ value: Bool) {
        if(skin=="No"){
            skin="Yes"
        } else{
            skin="No"
        }
    }
    
    @IBAction func painswitcher(_ value: Bool) {
        if(pain=="No"){
            pain="Yes"
        } else{
            pain="No"
        }
    }
    
    @IBAction func dischargeswitcher(_ value: Bool) {
        if(discharge=="No"){
            discharge="Yes"
        } else{
            discharge="No"
        }
    }
    
    @IBAction func buttonPressed() {
        print("Button Pressed")
        let data = ["Lump": lump,
                                   "Thickness": thickness,
                                   "Irritation": irritation,
                                   "Skin": skin,
                                   "Pain": pain,
                                   "Discharge": discharge] //Create your dictionary as per uses
        session.sendMessage(data, replyHandler: nil, errorHandler: nil)
    }
}

extension SymptomTracking: WCSessionDelegate {
  
  func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
  }
  
  func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
    print("received data: \(message)")
  }
}
