//
//  ShipSprite.swift
//  Asteroids
//
//  Created by Alex Fuerst on 9/26/16.
//

import Foundation
import SpriteKit

class ShipSprite:SKShapeNode{
    var fwd:CGPoint = CGPoint(x:0.0,y:1.0);
    var velocity:CGPoint = CGPoint.zero;
    var velocityMag:CGFloat = 3.0;
    var hit:Bool = false;
    var radius:CGFloat;
    let screenBounds:CGRect;
    
    init(size:CGSize,screenBounds:CGRect){
        radius = size.width/2.0;
        self.screenBounds = screenBounds;
        super.init();
        
        let top = CGPoint(x:0, y:radius);
        let right = CGPoint(x:radius, y:-radius);
        let center = CGPoint(x:0,y:-radius/2)
        let left = CGPoint(x:-radius,y:-radius);
        
        let pathToDraw = CGMutablePath();
        pathToDraw.move(to: top);
        pathToDraw.addLine(to: right);
        pathToDraw.addLine(to: center)
        pathToDraw.addLine(to: left);
        pathToDraw.closeSubpath();
        path = pathToDraw;
        
        if GameData.debugMode {
            let bounds = SKShapeNode.init(circleOfRadius: radius);
            bounds.strokeColor = SKColor.red;
            bounds.fillColor = SKColor.clear;
            self.addChild(bounds);
        }
        
        self.strokeColor = SKColor.red;
        self.lineWidth = 10;
        self.fillColor = SKColor.clear;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented");
    }
    
    func update(dt:CGFloat) {
        let gv = MotionMonitor.sharedMotionMonitor.gravityVectorNormalized
        var yVel = gv.dy
        yVel = yVel < -0.33 ? -0.33 : yVel
        yVel = yVel > 0.33 ? 0.33 : yVel
        
        if abs(yVel) < 0.1 {
            yVel = 0
        } else {
            yVel = (yVel * 15) * CGFloat.pi / 180.0
        }
        
        zRotation -= yVel;
        
        // this should ultimately check to see which orientation the phone is being held
        fwd.rotate(byRad: -yVel)
        
        var xVel = gv.dx - 0.6
        xVel = xVel < -0.33 ? -0.33 : xVel
        xVel = xVel > 0.33 ? 0.33 : xVel
        
        // again, this should check orientation before assuming it should flip the value
        xVel = -xVel
        
        if xVel < 0.1 {
            xVel = 0
        }
        
        xVel *= 3
        
        position = fwd * xVel * velocityMag + position
        
        checkBounds()
    }
    
    // check to see if the asteroid has gone off screen and wrap it back around
    func checkBounds() {
        
        if (position.x <= -radius){
            position = CGPoint(x: screenBounds.width-1, y: position.y);
        }
        
        if(position.x >= screenBounds.width + radius) {
            position = CGPoint(x: 1, y: position.y);
        }
        
        if(position.y <=  screenBounds.minY-radius){
            position = CGPoint(x: position.x, y: screenBounds.maxY-1 + radius);
        }
        
        if(position.y >= screenBounds.maxY + radius) {
            position = CGPoint(x: position.x, y: screenBounds.minY + 1 - radius);
        }
    }
}
