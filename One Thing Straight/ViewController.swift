//
//  ViewController.swift
//  One Thing Straight
//
//  Created by Zoe Roecker on 3/23/17.
//  Copyright © 2017 Zoe Roecker. All rights reserved.
//


import UIKit
import Bean_iOS_OSX_SDK


class ViewController: UIViewController, PTDBeanManagerDelegate, PTDBeanDelegate {
    
    @IBOutlet weak var ledTextLabel: UILabel!

    // Declare variables we will use throughout the app
    var beanManager: PTDBeanManager?
    var yourBean: PTDBean?
    var lightState: Bool = false
    
    
    // After view is loaded into memory, we create an instance of PTDBeanManager
    // and assign ourselves as the delegate
    override func viewDidLoad() {
        super.viewDidLoad()
        beanManager = PTDBeanManager()
        beanManager!.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ToggleButton(_ sender: UIButton) {
        if ledTextLabel.text == nil {
            ledTextLabel.text = "Led is: OFF"
            print("LED is: OFF")
        } else if ledTextLabel.text == "Led is: OFF" {
            ledTextLabel.text = "Led is: ON"
            print("LED is: ON")
        } else {
            ledTextLabel.text = "Led is: OFF"
            print("LED is: OFF")
        }
    }

    // After the view is added we will start scanning for Bean peripherals
    override func viewDidAppear(_ animated: Bool) {
        startScanning()
    }
    
    
    // Scan for Beans
    func startScanning() {
        var error: NSError?
        beanManager!.startScanning(forBeans_error: &error)
        if let e = error {
            print(e)
        }
    }

    func beanManagerDidUpdateState(_ beanManager: PTDBeanManager!) {
        if beanManager.state == BeanManagerState.poweredOn {
            var error: NSError?
            beanManager.startScanning(forBeans_error: &error)
            if error != nil {
                print( "Error attempting to connect to bean.\r\nError: \(error?.localizedDescription)" )
            }
            
        }
    }
    
    func beanManager(_ beanManagerDiscovered: PTDBeanManager!, didDiscover bean: PTDBean!, error: Error!) {
        let identifier = bean.identifier
        var error: NSError?
        
        beanManagerDiscovered?.connect(to: bean, withOptions: nil, error: &error)
        
        print (identifier!)
    }
    
    func beanManager(_ beanManager: PTDBeanManager!, didConnect bean: PTDBean!, error: Error!) {
        bean.delegate = self
        
        yourBean = bean
    }
    
    func beanManager(_ beanManager: PTDBeanManager!, didDisconnectBean bean: PTDBean!, error: Error!) {
        print ("Bean disconnected")
        if error != nil {
            print ("Error: ", error)
        }
    }
    
    // Bean SDK: Send serial datat to the Bean
    func sendSerialData(beanState: Data) {
        yourBean?.sendSerialData(beanState as Data!)
    }
    
    // Change LED text when button is pressed
    func updateLedStatusText(lightState: Bool) {
        let onOffText = lightState ? "ON" : "OFF"
        ledTextLabel.text = "Led is: \(onOffText)"
    }
    
    // Mark: Actions
    // When we pressed the button, we change the light state and
    // We update date the label, and send the Bean serial data
    @IBAction func pressMeButtonToToggleLED(sender: AnyObject) {
        lightState = !lightState
        updateLedStatusText(lightState: lightState)
        let data = NSData(bytes: &lightState, length: MemoryLayout<Bool>.size)
        sendSerialData(beanState: data as Data)
        
    }

}

