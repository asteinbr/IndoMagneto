//
//  ViewController.swift
//  IndoMagneto
//
//  Created by Alexander Steinbrecher on 20/12/14.
//  Copyright (c) 2014 Alexander Steinbrecher. All rights reserved.
//

import UIKit
import CoreMotion


extension Double {
    func toString() -> String {
        return String(format: "%.3f", self)
    }
}

class ViewController: UIViewController, UIAlertViewDelegate, UITextFieldDelegate {
    var isStarted = false
    lazy var motionManager = CMMotionManager()
    
    @IBOutlet weak var filenameLabel: UITextField!
    
    @IBOutlet weak var labelMagnetX: UILabel!
    @IBOutlet weak var labelMagnetY: UILabel!
    @IBOutlet weak var labelMagnetZ: UILabel!
    
    @IBOutlet weak var labelAccelerometerX: UILabel!
    @IBOutlet weak var labelAccelerometerY: UILabel!
    @IBOutlet weak var labelAccelerometerZ: UILabel!
    
    var magnetX = 0.000
    var magnetY = 0.000
    var magnetZ = 0.000
    var accelerometerX = 0.000
    var accelerometerY = 0.000
    var accelerometerZ = 0.000
    
    func startDataCollection() {
        
        // Motion Manager
        if isStarted {
            if motionManager.accelerometerAvailable & motionManager.magnetometerAvailable {
                
                // Accelerometer
                let queue = NSOperationQueue()
                motionManager.startAccelerometerUpdatesToQueue(queue, withHandler: {(data: CMAccelerometerData!, error: NSError!) in
                    
                    let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                    dispatch_async(dispatch_get_global_queue(priority, 0)) {
                        // do some task
                        self.accelerometerX = (data.acceleration.x)*10
                        self.accelerometerY = (data.acceleration.y)*10
                        self.accelerometerZ = (data.acceleration.z)*10
                        
                        dispatch_async(dispatch_get_main_queue()) {
                            // update some UI
                            self.labelAccelerometerX.text = self.accelerometerX.toString()
                            self.labelAccelerometerY.text = self.accelerometerY.toString()
                            self.labelAccelerometerZ.text = self.accelerometerZ.toString()
                        }
                    }
                })
                
                // Magnetometer
                let queueMagnet = NSOperationQueue()
                motionManager.startMagnetometerUpdatesToQueue(queueMagnet, withHandler: {(data: CMMagnetometerData!, error: NSError!) in
                    
                    let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                    dispatch_async(dispatch_get_global_queue(priority, 0)) {
                        // do some task
                        self.magnetX = (data.magneticField.x)
                        self.magnetY = (data.magneticField.y)
                        self.magnetZ = (data.magneticField.z)
                        
                        dispatch_async(dispatch_get_main_queue()) {
                            // update some UI
                            self.labelMagnetX.text = self.magnetX.toString()
                            self.labelMagnetY.text = self.magnetY.toString()
                            self.labelMagnetZ.text = self.magnetZ.toString()
                        }
                    }
                    
                })
                
            } else {
                println("Accelerometer and Magnetometer are not available.")
            }
        }
    }
    
    func pressStart(sender: AnyObject) {
        println("pressStart")
        isStarted = true
        var contentFilename = filenameLabel.text
        
        println("Filename is: " + contentFilename)
        
        if contentFilename.isEmpty {
            println("filename is empty")
            let alertView = UIAlertView(title: "Missing filename", message: "An empty filename is not allowed.", delegate: self, cancelButtonTitle: "OK")
            alertView.alertViewStyle = .Default
            alertView.show()
        } else {
            startDataCollection()
        }
    }
    
    func pressStop(sender: AnyObject) {
        println("pressStop")
        isStarted = false
        
        motionManager.stopAccelerometerUpdates()
        motionManager.stopMagnetometerUpdates()
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {   //delegate method
        textField.resignFirstResponder()
        
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        filenameLabel.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

