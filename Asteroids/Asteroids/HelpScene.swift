//
//  HelpScene.swift
//  Asteroids
//
//  Created by Alex Fuerst on 10/16/16.
//  Copyright © 2016 Alex Fuerst. All rights reserved.
//

import SpriteKit

class HelpScene: SKScene {
    let sceneManager:GameViewController
    let button:SKLabelNode = SKLabelNode(fontNamed: GameData.font.mainFont);
    
    init(size:CGSize, scaleMode:SKSceneScaleMode, sceneManager:GameViewController) {
        self.sceneManager = sceneManager
        super.init(size:size)
        self.scaleMode = scaleMode
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented");
    }
    
    override func didMove(to view: SKView) {
        backgroundColor = GameData.scene.backgroundColor
        
        let Title = SKLabelNode(fontNamed: GameData.font.mainFont)
        Title.text = "Instructions"
        Title.fontSize = 100
        Title.position = CGPoint(x:size.width/2,y:size.height/2 + 180)
        addChild(Title);
        
        let inst1 = SKLabelNode(fontNamed: GameData.font.mainFont)
        inst1.text = "Tilt forward to accelerate"
        inst1.fontSize = 32
        inst1.position = CGPoint(x:size.width/2,y:size.height/2 + 36)
        addChild(inst1);
        
        let inst2 = SKLabelNode(fontNamed: GameData.font.mainFont)
        inst2.text = "Tilt left to rotate counter-clockwise"
        inst2.fontSize = 32
        inst2.position = CGPoint(x:size.width/2,y:size.height/2)
        addChild(inst2);
        
        let inst3 = SKLabelNode(fontNamed: GameData.font.mainFont)
        inst3.text = "Tilt right to rotate clockwise"
        inst3.fontSize = 32
        inst3.position = CGPoint(x:size.width/2,y:size.height/2 - 36)
        addChild(inst3);
        
        let prompt = SKLabelNode(fontNamed: GameData.font.mainFont)
        prompt.text = "Tap to return home"
        prompt.fontSize = GameData.hud.fontSize
        prompt.position = CGPoint(x:size.width/2,y:size.height/2 - 180)
        addChild(prompt);
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        sceneManager.loadHomeScene();
    }
}
