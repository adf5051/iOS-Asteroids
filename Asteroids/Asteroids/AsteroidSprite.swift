//
//  DiamondSprite.swift
//  Asteroids
//
//  Created by Alex Fuerst on 9/26/16.
//

import Foundation
import SpriteKit

// Asteroid Sprite
class AsteroidSprite:SKShapeNode{
    
    // Enum to represent the asteroid's size
    public enum SizeState {
        case Large
        case Medium
        case Small
    }
    
    // the forward direction of the asteroid
    var fwd:CGPoint = CGPoint(x:0.0,y:1.0);
    
    // the current velocity of the asteroid
    var velocity:CGPoint = CGPoint.zero;
    
    // the magnitude of velocity vector
    private var velocityMag:CGFloat = 50.0;
    
    //var hit:Bool = false;
    
    // the radius to use for collisions
    var avgRadius:CGFloat = 0.0;
    
    // playable area of the screen used for screen wrap
    private let screenBounds:CGRect;
    
    // the current size of the asteroid
    private let sizeState: SizeState;
    
    // the point value for destroying this asteroid
    private var pointValue: Int = 0;
    
    // accessor for the size of the asteroid
    func getSizeState() ->SizeState {
        return self.sizeState
    }
    
    // accessor for the point value of the asteroid
    func getPointValue() -> Int {
        return pointValue
    }
    
    init(screenBounds:CGRect, sizeState:SizeState, level:Int){
        
        self.screenBounds = screenBounds;
        self.sizeState = sizeState;
        
        super.init();
        
        var radius:CGFloat = 20;
        
        // based upon the size of the asteroid set the radius value, the velocity, and the point value
        switch sizeState {
        case .Large:
            radius *= 3
            pointValue = 5
            self.velocityMag += CGFloat(level * 5)
            break
        case .Medium:
            radius *= 2
            pointValue = 10
            self.velocityMag += CGFloat(level * 5) + 10
            break
        default:
            pointValue = 20
            self.velocityMag += CGFloat(level * 5) + 20
            break;
        }
        
        var x = 0.0
        var y = 0.0
        var rand:CGFloat = 0.0
        
        // the min and max radius possible per point
        let high:CGFloat = radius * 1.5
        let low:CGFloat = radius * 0.5
        
        let pathToDraw = CGMutablePath();
        
        // calculate a ten sided shape with random points around an origin
        // also grab an average radius from these points
        for i in 0 ..< 10 {
        
            rand = CGFloat.random(min: low, max: high);
            avgRadius += rand;
            
            x = cos(Double(i) * Double.pi/5) * Double(rand);
            y = sin(Double(i) * Double.pi/5) * Double(rand);
            
            if i == 0 {
                pathToDraw.move(to: CGPoint(x: x, y: y));
            }else{
                pathToDraw.addLine(to: CGPoint(x: x, y: y));
            }
        }
        
        avgRadius /= 10;
        
        pathToDraw.closeSubpath();
        path = pathToDraw;
        
        // if debug mode show the user the bounding circle we are using for collisions
        if GameData.debugMode {
            let bounds = SKShapeNode.init(circleOfRadius: avgRadius);
            bounds.strokeColor = SKColor.red;
            bounds.fillColor = SKColor.clear;
            self.addChild(bounds);
        }
        
        self.strokeColor = SKColor.white;
        self.lineWidth = 5;
        self.fillColor = SKColor.clear;
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented");
    }
    
    // called by game loop to update this sprite
    func update(dt:CGFloat) {
        velocity = fwd * velocityMag;
        position = position + velocity * dt;
        checkBounds()
        
    }
    
    // called to check if this asteroid is colliding with a given point and radius on the screen
    func isColliding(position: CGPoint, radius: CGFloat) -> Bool{
        
        let vBetween: CGPoint = position - self.position;
        
        let minDist = radius + self.avgRadius
        
        if vBetween.length() > minDist {
            if GameData.debugMode {
                self.strokeColor = SKColor.white;
            }
            
            return false
        }
        
        if GameData.debugMode {
            self.strokeColor = SKColor.red;
        }
        
        return true;
    }
    
    // check to see if the asteroid has gone off screen and wrap it back around
    func checkBounds() {

        if (position.x <= -avgRadius){
            position = CGPoint(x: screenBounds.width-1, y: position.y);
        }
        
        if(position.x >= screenBounds.width + avgRadius) {
            position = CGPoint(x: 1, y: position.y);
        }
        
        if(position.y <=  screenBounds.minY-avgRadius){
            position = CGPoint(x: position.x, y: screenBounds.maxY-1 + avgRadius);
        }
        
        if(position.y >= screenBounds.maxY + avgRadius) {
            position = CGPoint(x: position.x, y: screenBounds.minY + 1 - avgRadius);
        }
    }
}
