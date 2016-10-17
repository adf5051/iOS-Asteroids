//
//  HomeScreen.swift
//  Asteroids
//
//  Created by Alex Fuerst on 9/26/16.
//

import SpriteKit;

class HomeScreen: SKScene {
    
    // MARK: - ivars -
    
    // the view controller
    let sceneManager:GameViewController;
    
    private var gameLabel: SKLabelNode!
    private var helpLabel: SKLabelNode!
    
    //let button:SKLabelNode = SKLabelNode(fontNamed: GameData.font.mainFont);
    
    // MARK: - Initialization - 
    
    init(size: CGSize, scaleMode:SKSceneScaleMode, sceneManager:GameViewController) {
        self.sceneManager = sceneManager;
        super.init(size:size);
        self.scaleMode = scaleMode;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented");
    }
    
    // MARK: - Lifecycle -
    
    // this screen has moved to view
    override func didMove(to view: SKView) {
        
        backgroundColor = GameData.scene.backgroundColor;
        
        let Title = SKLabelNode(fontNamed: GameData.font.mainFont);
        let Author = SKLabelNode(fontNamed: GameData.font.mainFont);
        Title.text = "Asteroids";
        Author.text = "By Alex Fuerst";
        
        Title.fontSize = GameData.hud.fontSize;
        Author.fontSize = GameData.hud.smallFont;
        
        Title.position = CGPoint(x:size.width/2, y:size.height/2 + 180);
        Author.position = CGPoint(x:size.width/2, y:size.height/2 + 140);
        
        Title.zPosition = 1;
        Author.zPosition = 1;
        addChild(Title);
        addChild(Author);
        
        gameLabel = SKLabelNode(fontNamed: GameData.font.mainFont);
        gameLabel.text = "Enter Space";
        gameLabel.fontSize = GameData.hud.fontSize;
        gameLabel.position = CGPoint(x:size.width/2, y:size.height/2);
        addChild(gameLabel);
        
        helpLabel = SKLabelNode(fontNamed: GameData.font.mainFont);
        helpLabel.text = "Flight Manual";
        helpLabel.fontSize = GameData.hud.fontSize;
        helpLabel.position = CGPoint(x:size.width/2, y:size.height/2 - 100);
        addChild(helpLabel);
    }
    
    // move to the game screen when tapped
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //sceneManager.loadGameScene(levelNum: 1, totalScore: 0);
        if let touch = touches.first {
            if gameLabel.frame.contains(touch.location(in: self)) {
                sceneManager.loadGameScene()
            }
            if helpLabel.frame.contains(touch.location(in: self)) {
                sceneManager.loadHelpScene()
            }
        }
        
        
        //if gameLabel.frame.contains(touches[0])
    }
}
