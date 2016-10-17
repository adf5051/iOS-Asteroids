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
    
    var velocity:CGPoint = CGPoint.zero {
        didSet {
            if(velocity.length() >= velocityMag) {
                velocity = velocity.normalized() * velocityMag
            }
        }
    }
    private let velocityMag:CGFloat = 200.0;
    private let rotationScalar:Int = 4;
    private let radius:CGFloat;
    private let screenBounds:CGRect;
    private let friction:CGFloat = 0.09
    private var spritesPaused:Bool = true;
    private let invAnimation:SKAction = SKAction.sequence([SKAction.fadeOut(withDuration: 0.2), SKAction.fadeIn(withDuration: 0.2)]
)
    var invincible:Bool = false {
        didSet {
            if invincible {
                run(SKAction.repeat(invAnimation, count: Int(maxInvTime/CGFloat(invAnimation.duration))))
            }
        }
    }
    private let maxInvTime:CGFloat = 3.0
    private var timeInv:CGFloat = 0 {
        didSet {
            if timeInv >= maxInvTime {
                timeInv = 0
                invincible = false
            }
        }
    }
    
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
        velocity = fwd;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented");
    }
    
    func getRadius() -> CGFloat {
        return radius
    }
    
    func pause() {
        spritesPaused = true;
    }
    
    func unPause() {
        spritesPaused = false;
    }
    
    func update(dt:CGFloat) {
        if !spritesPaused {
            
            if invincible {
                timeInv += dt;
            }
            
            let gv = MotionMonitor.sharedMotionMonitor.gravityVectorNormalized
            var yVel = gv.dy
            yVel = yVel < -0.33 ? -0.33 : yVel
            yVel = yVel > 0.33 ? 0.33 : yVel
            
            if abs(yVel) < 0.1 {
                yVel = 0
            } else {
                yVel = (CGFloat(rotationScalar) * yVel * 100) * CGFloat.pi / 180.0
            }
            
            zRotation -= yVel * dt;
            
            // this should ultimately check to see which orientation the phone is being held
            fwd.rotate(byRad: -yVel * dt)
            velocity.rotate(byRad: -yVel * dt)
            
            var xVel = gv.dx - 0.6
            xVel = xVel < -0.33 ? -0.33 : xVel
            xVel = xVel > 0.33 ? 0.33 : xVel
            
            // again, this should check orientation before assuming it should flip the value
            xVel = -xVel
            
            if xVel < 0.1 {
                xVel = 0
            }
            
            xVel *= 3
            
            velocity = fwd * xVel * velocityMag * dt;
            
            position = velocity + position
            
            checkBounds()
        }
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
