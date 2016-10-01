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
    var delta:CGFloat = 75.0;
    var hit:Bool = false;
    var radius:CGFloat;
    
    init(size:CGSize){
        radius = size.width/2.0;
        
        super.init();
        let halfHeight = size.height/2.0;
        let halfWidth = size.width/2.0;
        let top = CGPoint(x:0, y:halfHeight);
        let right = CGPoint(x:halfWidth, y:-halfHeight);
        let left = CGPoint(x:-halfWidth,y:-halfHeight);
        
        let pathToDraw = CGMutablePath();
        pathToDraw.move(to: top);
        pathToDraw.addLine(to: right);
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
        velocity = fwd * delta;
        position = position + velocity * dt;
    }
    
    func reflectX() {
        fwd.x *= CGFloat(-1.0);
    }
    
    func reflectY() {
        fwd.y *= CGFloat(-1.0);
    }
}
