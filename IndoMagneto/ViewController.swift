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

class ViewController: UIViewController {
    
    lazy var motionManager = CMMotionManager()
    
    @IBOutlet weak var filenameLabel: UITextField!
    
    @IBOutlet weak var labelMagnetX: UILabel!
    @IBOutlet weak var labelMagnetY: UILabel!
    @IBOutlet weak var labelMagnetZ: UILabel!
    
    @IBOutlet weak var labelAccelerometerX: UILabel!
    @IBOutlet weak var labelAccelerometerY: UILabel!
    @IBOutlet weak var labelAccelerometerZ: UILabel!
    
    
    @IBAction func pressStart(sender: AnyObject) {
        println("pressStart")
    }
    
    @IBAction func pressStop(sender: AnyObject) {
        println("pressStop")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Motion Manager
        if motionManager.accelerometerAvailable & motionManager.magnetometerAvailable {
            let queue = NSOperationQueue()
            motionManager.startAccelerometerUpdatesToQueue(queue, withHandler: {(data: CMAccelerometerData!, error: NSError!) in
                
                self.labelAccelerometerX.text = (data.acceleration.x).toString()
                self.labelAccelerometerY.text = (data.acceleration.y).toString()
                self.labelAccelerometerZ.text = (data.acceleration.z).toString()
                
                var outputA1 = "A: "
                var outputA2 = (data.acceleration.x).toString() + ", " + (data.acceleration.y).toString() + ", " + (data.acceleration.z).toString()
                println(outputA1 + outputA2)
                //println("A: " + (data.acceleration.x).toString() + ", " + (data.acceleration.y).toString() + ", " + (data.acceleration.z).toString())
                
            })
            
            let queueMagnet = NSOperationQueue()
            motionManager.startMagnetometerUpdatesToQueue(queueMagnet, withHandler: {(data: CMMagnetometerData!, error: NSError!) in
                
                self.labelMagnetX.text = (data.magneticField.x).toString()
                self.labelMagnetY.text = (data.magneticField.y).toString()
                self.labelMagnetZ.text = (data.magneticField.z).toString()
                
                var outputM1 = "M: "
                var outputM2 = (data.magneticField.x).toString() + ", " + (data.magneticField.y).toString() + ", " + (data.magneticField.z).toString()
                println(outputM1 + outputM2)
                //println("M: " + (data.magneticField.x).toString() + ", " + (data.magneticField.y).toString() + ", " + (data.magneticField.z).toString())
                
            })
            
        } else {
            println("Accelerometer and Magnetometer are not available.")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

