//
//  SensorsModel.swift
//  CrazyDriver
//
//  Created by Alberti Terence on 30/05/16.
//  Copyright © 2016 TA. All rights reserved.
//

import UIKit
import CoreMotion

public class SensorsModel: NSObject {

    let motionManager = CMMotionManager()
    public var currentRotationX : Double = 0
    public var currentRotationY : Double = 0
    public var currentRotationZ : Double = 0
    
    override init(){
        super.init()
        
        self.motionManager.accelerometerUpdateInterval = NSTimeInterval(0.2)
        let currentQueue = NSOperationQueue.currentQueue()
        
        self.motionManager.startAccelerometerUpdatesToQueue(currentQueue!) { (accelerometerData, error) in
            self.currentRotationX = accelerometerData!.acceleration.x
            self.currentRotationZ = accelerometerData!.acceleration.z
            self.currentRotationY = (accelerometerData!.acceleration.y < 0.05 && accelerometerData!.acceleration.y > Double(-0.05) ) ? 0 : accelerometerData!.acceleration.y    // don't keep if too tiny
        }
    }
}
