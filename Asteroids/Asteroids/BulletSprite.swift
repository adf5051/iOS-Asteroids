//
//  BulletSprite.swift
//  Asteroids
//
//  Created by Alex Fuerst on 9/26/16.
//

import Foundation
import SpriteKit

// Bullet Sprite
class BulletSprite:SKShapeNode{
    
    // the forward direction of the asteroid
    var fwd:CGPoint = CGPoint(x:0.0,y:1.0);
    
    var life:CGFloat = 0.0
    
    // the current velocity of the asteroid
    var velocity:CGPoint = CGPoint.zero;
    
    // the magnitude of velocity vector
    private var velocityMag:CGFloat = 500.0;
    
    let radius:CGFloat = 5;
    
    // playable area of the screen used for screen wrap
    private let screenBounds:CGRect;
    
    init(screenBounds:CGRect, fwd:CGPoint){
        
        self.screenBounds = screenBounds;
        self.fwd = fwd
        
        super.init();
        
        // this is hacky as hell, lets keep it for novelty
        path = SKShapeNode.init(circleOfRadius: radius).path;
        
        self.strokeColor = SKColor.white;
        self.lineWidth = 5;
        self.fillColor = SKColor.white;
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented");
    }
    
    // called by game loop to update this sprite
    func update(dt:CGFloat) {
        velocity = fwd * velocityMag;
        position = position + velocity * dt;
        checkBounds()
        life += dt
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
