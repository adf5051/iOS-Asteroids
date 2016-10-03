//
//  CGPoint+Extensions.swift
//  Asteroids
//
//  Created by jefferson on 9/14/16.
//  Copyright © 2016 tony. All rights reserved.
//

import CoreGraphics
func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

func / (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x / scalar, y: point.y / scalar)
}

#if !(arch(x86_64) || arch(arm64))
    func sqrt(a: CGFloat) -> CGFloat {
        return CGFloat(sqrtf(Float(a)))
    }
#endif

extension CGPoint {
    func length() -> CGFloat {
        return sqrt(x*x + y*y)
    }
    
    func normalized() -> CGPoint {
        return self / length()
    }
    
    /**
     * Returns the angle in radians of the vector described by the CGVector.
     * The range of the angle is -π to π; an angle of 0 points to the right.
     */
    public var angle: CGFloat {
        return atan2(y, x)
    }
    
    /**
     * Rotates this vector by a given radian amount
     */
    public mutating func rotate(byRad: CGFloat){
        var angle = self.angle
        angle += byRad;
        let length = self.length()
        self.x = length * cos(angle);
        self.y = length * sin(angle);
    }
}
