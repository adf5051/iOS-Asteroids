//
//  GameOverScene.swift
//  Asteroids
//
//  Created by Alex Fuerst on 9/26/16.
//

import SpriteKit

class GameOverScene: SKScene {
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
        
        let label = SKLabelNode(fontNamed: GameData.font.mainFont)
        label.text = "Game Over"
        label.fontSize = 100
        label.position = CGPoint(x:size.width/2,y:size.height/2)
        addChild(label);
        
        let label3 = SKLabelNode(fontNamed: GameData.font.mainFont)
        label3.text = "Tap to try again"
        label3.fontSize = 70
        label3.position = CGPoint(x:size.width/2,y:size.height/2 - 100)
        addChild(label3);
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        sceneManager.loadHomeScene();
    }
}
