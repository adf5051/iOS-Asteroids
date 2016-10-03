//
//  MotionMonitor.swift
//  Shooter1
//
//  Created by Alex Fuerst on 9/29/16.
//  Copyright © 2016 Alex Fuerst. All rights reserved.
//

import Foundation
import CoreMotion
import CoreGraphics

class MotionMonitor {
    static let sharedMotionMonitor = MotionMonitor();
    
    let manager = CMMotionManager();
    var rotation:CGFloat = 0;
    var gravityVectorNormalized = CGVector.zero;
    var gravityVector = CGVector.zero;
    var transform = CGAffineTransform(rotationAngle: 0);
    
    private init() {}
    
    func startUpdates() {
        if manager.isDeviceMotionAvailable {
            print("** starting motion updates **");
            
            manager.deviceMotionUpdateInterval = 0.1;
            
            manager.startDeviceMotionUpdates(to: OperationQueue.main) {
                data, error in
                guard data != nil else {
                    print("ERROR");
                    return;
                }
                
                self.rotation = CGFloat(atan2(data!.gravity.x,data!.gravity.y)) - CGFloat.pi;
                
                self.gravityVectorNormalized = CGVector(dx:CGFloat(data!.gravity.x),dy:CGFloat(data!.gravity.y));
                
                self.gravityVector = CGVector(dx:CGFloat(data!.gravity.x),dy:CGFloat(data!.gravity.y)) * 9.8;
                
                print("self.rotation = \(self.rotation)")
                print("self.gravityVectorNormalized = \(self.gravityVectorNormalized)")
            }
            
        }else{
                print("device motion is not available");
        }
    }
    
    func stopUpdates() {
        print("** stopping motion updates**");
        if manager.isDeviceMotionAvailable {
            manager.stopDeviceMotionUpdates()
        }
    }
}
