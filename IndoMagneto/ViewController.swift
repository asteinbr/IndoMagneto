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
        return String(format: "%.2f", self)
    }
}

class ViewController: UIViewController, UIAlertViewDelegate, UITextFieldDelegate {
    var isStarted = false
    var motionManager = CMMotionManager()
    var deviceMotion = CMDeviceMotion()
    
    @IBOutlet weak var filenameLabel: UITextField!
    
    @IBOutlet weak var labelMagnetX: UILabel!
    @IBOutlet weak var labelMagnetY: UILabel!
    @IBOutlet weak var labelMagnetZ: UILabel!
    
    @IBOutlet weak var labelAccelerometerX: UILabel!
    @IBOutlet weak var labelAccelerometerY: UILabel!
    @IBOutlet weak var labelAccelerometerZ: UILabel!
    
    @IBOutlet weak var labelGyroX: UILabel!
    @IBOutlet weak var labelGyroY: UILabel!
    @IBOutlet weak var labelGyroZ: UILabel!
    
    @IBOutlet weak var labelYaw: UILabel!
    @IBOutlet weak var labelPitch: UILabel!
    @IBOutlet weak var labelRoll: UILabel!
    
    var magnetX = 0.000
    var magnetY = 0.000
    var magnetZ = 0.000
    var accelerometerX = 0.000
    var accelerometerY = 0.000
    var accelerometerZ = 0.000
    var magnet2X = 0.000
    var magnet2Y = 0.000
    var magnet2Z = 0.000
    var gyroX = 0.000
    var gyroY = 0.000
    var gyroZ = 0.000
    var attitudeYaw = 0.000
    var attitudePitch = 0.000
    var attitudeRoll = 0.000
    
    var lastItem = "NEWFILE"
    var data = ""
    var myStopTimer:NSTimer?
    
    func writeToInternalFile(currentData: String) {
        if lastItem.hasPrefix("NEWFILE") {
            if currentData.hasPrefix("ORIENTATION") {
                data = data + currentData
                lastItem = currentData
            }
        }
        if lastItem.hasPrefix("ORIENTATION") {
            if currentData.hasPrefix("ACCELEROMETER") {
                data = data + currentData
                lastItem = currentData
            }
        }
        if lastItem.hasPrefix("ACCELEROMETER") {
            if currentData.hasPrefix("MAGNETIC_FIELD") {
                data = data + currentData
                lastItem = currentData
            }
        }
        if lastItem.hasPrefix("MAGNETIC_FIELD") {
            if currentData.hasPrefix("GYROSCOPE") {
                data = data + currentData
                lastItem = currentData
            }
        }
        if lastItem.hasPrefix("GYROSCOPE") {
            if currentData.hasPrefix("ORIENTATION") {
                data = data + currentData
                lastItem = currentData
            }
        }
    }
    
    func startDataCollection() {
        
        // Motion Manager
        if isStarted {
            if motionManager.accelerometerAvailable & motionManager.magnetometerAvailable & motionManager.gyroAvailable {
                
                // Accelerometer
                motionManager.accelerometerUpdateInterval = 0.1
                let queue = NSOperationQueue()
                motionManager.startAccelerometerUpdatesToQueue(queue, withHandler: {(data: CMAccelerometerData!, error: NSError!) in
                    
                    let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                    dispatch_async(dispatch_get_global_queue(priority, 0)) {
                        // do some task
                        self.accelerometerX = (data.acceleration.x) * 9.81
                        self.accelerometerY = (data.acceleration.y) * 9.81
                        self.accelerometerZ = (data.acceleration.z) * 9.81
                        
                        var orientationData = "0.0,0.0,0.0\n"
                        self.writeToInternalFile("ORIENTATION," + orientationData)
                        
                        var accelData = self.accelerometerX.toString() + "," + self.accelerometerY.toString() + "," + self.accelerometerZ.toString() + "\n"
                        self.writeToInternalFile("ACCELEROMETER," + accelData)
                        
                        dispatch_async(dispatch_get_main_queue()) {
                            // update some UI
                            self.labelAccelerometerX.text = self.accelerometerX.toString()
                            self.labelAccelerometerY.text = self.accelerometerY.toString()
                            self.labelAccelerometerZ.text = self.accelerometerZ.toString()
                        } // dispatch_async main_queue
                    } // dispatch_async global_queue
                })
                
                // Magnetometer Corrected
                let queueMagnetCorrected = NSOperationQueue()
                if motionManager.deviceMotionAvailable {
                    motionManager.deviceMotionUpdateInterval = 0.1
                    motionManager.startDeviceMotionUpdatesUsingReferenceFrame(CMAttitudeReferenceFrameXArbitraryCorrectedZVertical, toQueue: queueMagnetCorrected, withHandler: {(data: CMDeviceMotion!, error: NSError!) in
                        
                        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                        dispatch_async(dispatch_get_global_queue(priority, 0)) {
                            // do some task
                            self.magnetX = (data.magneticField.field.x)
                            self.magnetY = (data.magneticField.field.y)
                            self.magnetZ = (data.magneticField.field.z)
                            
                            var magnetData = self.magnetX.toString() + "," + self.magnetY.toString() + "," + self.magnetZ.toString() + "\n"
                            self.writeToInternalFile("MAGNETIC_FIELD," + magnetData)
                            
                            dispatch_async(dispatch_get_main_queue()) {
                                // update some UI
                                self.labelMagnetX.text = self.magnetX.toString()
                                self.labelMagnetY.text = self.magnetY.toString()
                                self.labelMagnetZ.text = self.magnetZ.toString()
                            }
                        } // dispatch_async
                    }) // startDeviceMotionUpdatesToQueue
                }
                
                // Gyroscope
                motionManager.gyroUpdateInterval = 0.1
                let queueGyro = NSOperationQueue()
                motionManager.startGyroUpdatesToQueue(queueGyro, withHandler: {(data: CMGyroData!, error: NSError!) in
                    
                    let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                    dispatch_async(dispatch_get_global_queue(priority, 0)) {
                        // do some task
                        self.gyroX = (data.rotationRate.x)
                        self.gyroY = (data.rotationRate.y)
                        self.gyroZ = (data.rotationRate.z)
                        
                        var gyroData = self.gyroX.toString() + "," + self.gyroY.toString() + "," + self.gyroZ.toString() + "\n"
                        self.writeToInternalFile("GYROSCOPE," + gyroData)
                        
                        dispatch_async(dispatch_get_main_queue()) {
                            // update some UI
                            self.labelGyroX.text = self.gyroX.toString()
                            self.labelGyroY.text = self.gyroY.toString()
                            self.labelGyroZ.text = self.gyroZ.toString()
                        } // dispatch_async main_queue
                    } // dispatch_async global_queue
                })
            } else {
                println("Accelerometer, Magnetometer or Gyroscope are not available.")
            }
        }
    }
    
    func doHTTPStuff() {
        let fileUpload = FileUploader()
        let fileName = filenameLabel.text + ".txt"
        fileUpload.nativeUpload(fileName, data: data)
        
    }
    
    func pressStart(sender: AnyObject) {
        println("pressStart")
        isStarted = true
        
        if !filenameLabel.text.isEmpty {
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
        
        startStopTimer()
        
    }
    
    func startStopTimer() {
        myStopTimer = NSTimer(timeInterval: 0.01, target: self, selector: "doStopTimerTasks", userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(myStopTimer!, forMode: NSRunLoopCommonModes)
    }
    
    func doStopTimerTasks() {
        if lastItem.hasPrefix("GYROSCOPE") {
            myStopTimer?.invalidate()
            myStopTimer = nil
            
            isStarted = false
            
            motionManager.stopAccelerometerUpdates()
            motionManager.stopMagnetometerUpdates()
            motionManager.stopDeviceMotionUpdates()
            motionManager.stopGyroUpdates()
            
            doHTTPStuff()
        }
    }
    
    // That after a press on Return the keyboard is disappearing
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

