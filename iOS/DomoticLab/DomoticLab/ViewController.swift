//
//  ViewController.swift
//  DomoticLab
//
//  Created by Riccardo Manoni on 16/07/17.
//  Copyright © 2017 Riccardo Manoni. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ViewController: UIViewController {

    @IBOutlet weak var buttonOpenIn: UIButton!
    @IBOutlet weak var buttonLed: UIButton!
    @IBOutlet weak var labelPublicIp: UILabel!
    @IBOutlet weak var labelStatoLed: UILabel!
    @IBOutlet weak var labelPoweredBy: UILabel!
    
    @IBOutlet weak var labelTemperature: UILabel!
    @IBOutlet weak var labelPressure: UILabel!
    @IBOutlet weak var labelLastUpdate: UILabel!
    
    var ledStatus = ""
    var publicIp = ""
    var temperature = ""
    var pressure = ""
    var updated = ""
    
    let bgColor = UIColor(red: 24.0/255.0, green: 116.0/255.0, blue: 119.0/255.0, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Domotic Lab"
        view.backgroundColor = bgColor
        
        // init labels
        labelPublicIp.textColor = UIColor.white
        labelPublicIp.font = UIFont(name: "Avenir-Light", size: 20.0)
        
        labelStatoLed.textColor = UIColor.white
        labelStatoLed.font = UIFont(name: "Avenir-Light", size: 20.0)
        
        labelTemperature.textColor = UIColor.white
        labelTemperature.font = UIFont(name: "Avenir-Light", size: 20.0)
        
        labelPressure.textColor = UIColor.white
        labelPressure.font = UIFont(name: "Avenir-Light", size: 20.0)
        
        labelLastUpdate.textColor = UIColor.white
        labelLastUpdate.font = UIFont(name: "Avenir-Light", size: 20.0)
        
        labelPoweredBy.textColor = UIColor.white
        labelPoweredBy.font = UIFont(name: "Avenir-Light", size: 20.0)
        labelPoweredBy.adjustsFontSizeToFitWidth = true
        labelPoweredBy.text = "Powered by: Raspberry Pi + Firebase Realtime Database + Adafruit BMP280"
        
        // init buttons
        buttonOpenIn.backgroundColor = UIColor.yellow
        buttonOpenIn.layer.cornerRadius = 8
        buttonOpenIn.layer.borderWidth = 1
        buttonOpenIn.layer.borderColor = UIColor.white.cgColor
        
        buttonLed.backgroundColor = UIColor.yellow
        buttonLed.layer.cornerRadius = 8
        buttonLed.layer.borderWidth = 1
        buttonLed.layer.borderColor = UIColor.white.cgColor
        
        // get a root reference of the Firebase Realtime Database
        let ref = FIRDatabase.database().reference()
        
        // Public Ip
        ref.child("Ip").observe(.value, with: { (snapshot) in
            self.publicIp = snapshot.value as! String
            self.labelPublicIp.text = "Public Ip: \(self.publicIp)"
        })

        // Led
        ref.child("Led").observe(.value, with: { (snapshot) in
            self.ledStatus = snapshot.value as! String
            self.labelStatoLed.text = "Led: Led is \(self.ledStatus)"
            if(self.ledStatus == "On") {
                self.buttonLed.setTitle("Turn Off Led", for: .normal)
            } else if(self.ledStatus == "Off") {
                self.buttonLed.setTitle("Turn On Led", for: .normal)
            }
            print("viewDidLoad() Stato led: \(String(describing: self.ledStatus))")
        })
        
        // Temperature
        ref.child("Temperature").observe(.value, with: { (snapshot) in
            self.temperature = snapshot.value as! String
            self.labelTemperature.text = "Temperature °C: \(self.temperature)"
        })
        
        ref.child("Temperature").observe(.value, with: { (snapshot) in
            self.temperature = snapshot.value as! String
            self.labelTemperature.text = "Temperature °C: \(self.temperature)"
            print("viewDidLoad() Temperatura: \(String(describing: self.temperature))")
        })
        
        // Pressure
        ref.child("Pressure").observe(.value, with: { (snapshot) in
            self.pressure = snapshot.value as! String
            self.labelPressure.text = "Pressure hPa: \(self.pressure)"
        })
        
        ref.child("Pressure").observe(.value, with: { (snapshot) in
            self.pressure = snapshot.value as! String
            self.labelPressure.text = "Pressure hPa: \(self.pressure)"
            print("viewDidLoad() Pressure hPa: \(String(describing: self.pressure))")
        })
        
        // Last Update
        ref.child("Updated").observe(.value, with: { (snapshot) in
            self.updated = snapshot.value as! String
            self.labelLastUpdate.text = "Last update: \(self.updated)"
            print("viewDidLoad() Last update: \(String(describing: self.updated))")
        })
    }
    
    
    @IBAction func ledOnOff(_ sender: Any) {
        let ref = FIRDatabase.database().reference().child("Led")
        if(self.ledStatus == "On") {
            //ref.updateChildValues(["Led":"Off"])
            ref.setValue("Off")
            self.labelStatoLed.text = "Led: Led is Off"
        } else if(self.ledStatus == "Off") {
            //ref.updateChildValues(["Led":"On"])
            ref.setValue("On")
            self.labelStatoLed.text = "Led: Led is On"
        }
    }

    @IBAction func openUrl(_ sender: UIButton) {
        if publicIp != "" {
            let url = URL(string: "http://\(publicIp)")!
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

