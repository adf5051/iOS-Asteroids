//
//  GameScene.swift
//  Asteroids
//
//  Created by Alex Fuerst on 9/26/16.
//

import SpriteKit;
import GameplayKit;

// the main game screen and game loop
class GameScene: SKScene {
    
    // the current score observer
    // updates the appropriate label when changed
    var levelScore:Int = 0 {
        didSet {
            if (levelScore > oldValue) {
                scoreLabel.text = "Score: \(levelScore)";
            }
        }
    }
    
    // the playable area of the screen
    private var playableRect = CGRect.zero;
    
    // time last frame used for calculating delta time
    private var lastUpdateTime: TimeInterval = 0;
    
    // delta time, aka time between frames
    private var dt:TimeInterval = 0;
    
    // bool used to start the movement of sprites
    private var spritesMoving = false;
    
    private var tapCount = 0;
    
    // the view controller
    private let sceneManager:GameViewController;
    
    // label for displaying the current score
    private let scoreLabel = SKLabelNode(fontNamed: GameData.font.mainFont);
    
    private let otherLabel = SKLabelNode(fontNamed: GameData.font.mainFont);
    
    // the player sprite
    private var ship:ShipSprite?;
    
    // MARK: - Initialization -
    init(size: CGSize, scaleMode:SKSceneScaleMode, sceneManager:GameViewController) {
        self.sceneManager = sceneManager;
        super.init(size: size);
        self.scaleMode = scaleMode;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented");
    }
    
    // MARK: - Lifecycle -
    
    // set up this view when loaded
    override func didMove(to view: SKView) {
        setupUI();
        makeAsteroidSprite(howMany: 5);
        makePlayerSprite();
        unpauseSprites();
    }
    
    deinit {
        // TODO: Clean up resources
    }
    
    // MARK: - Helpers -
    
    // Set up the HUD for the game
    private func setupUI() {
        
        // calculate the actual game area of the screen
        playableRect = getPlayableRectPhonePortrait(size: size);
        //playableRect = CGRect(x: 0, y: 0, width: size.width, height: size.height);
        
        // grab the hud settings from the GameData
        let fontSize = GameData.hud.fontSize;
        let fontColor = GameData.hud.fontColorWhite;
        let marginH = GameData.hud.marginH;
        let marginV = GameData.hud.marginV;
        
        backgroundColor = GameData.hud.backgroundColor;
        
        scoreLabel.fontColor = fontColor;
        scoreLabel.fontSize = fontSize;
        
        scoreLabel.verticalAlignmentMode = .top;
        scoreLabel.horizontalAlignmentMode = .left;
        
        // give score label a basic text so that it's max size can be calculated
        scoreLabel.text = "Score: 0000";
        let scoreLabelWidth = scoreLabel.frame.size.width;
        
        // replace the text with the actual score
        scoreLabel.text = "Score: \(levelScore)";
        
        scoreLabel.position = CGPoint(x: playableRect.maxX - scoreLabelWidth - marginH, y:playableRect.maxY - marginV);
        addChild(scoreLabel);
        
        /*
        otherLabel.fontColor = fontColor;
        otherLabel.fontSize = fontSize;
        otherLabel.position = CGPoint(x:marginH, y: playableRect.minY + marginV);
        otherLabel.verticalAlignmentMode = .bottom;
        otherLabel.horizontalAlignmentMode = .left;
        otherLabel.text = "Numb Sprites: 0";
        addChild(otherLabel);
         */
    }
    
    // make the player
    func makePlayerSprite() {
        ship = ShipSprite(size: CGSize(width: 60, height:100),screenBounds:playableRect);
        ship!.name = "player";
        ship!.position = CGPoint(x:self.size.width/2,y:self.size.height/2);
        ship!.fwd = CGPoint(x:0,y:1);
        addChild(ship!);
    }
    
    // create a givent number of asteroid instances from an optional parent
    func makeAsteroidSprite(howMany:Int, parentAsteroid:AsteroidSprite? = nil) {
        var s:AsteroidSprite;
        for _ in 0...howMany-1 {
            
            // if the parent asteroid is nil assume we are starting the level and create large asteroids
            if parentAsteroid == nil {
                s = AsteroidSprite(screenBounds:playableRect,sizeState:AsteroidSprite.SizeState.Large, level: 0);
                s.position = randomCGPointOutsideRect(playableRect);
            } else {
                
                // grab the size of the parent asteroid and make the new asteroid one smaller
                switch parentAsteroid!.getSizeState() {
                case .Large:
                    s = AsteroidSprite(screenBounds:playableRect,sizeState:AsteroidSprite.SizeState.Medium, level: 0);
                    s.position = parentAsteroid!.position;
                    break;
                case .Medium:
                    s = AsteroidSprite(screenBounds:playableRect,sizeState:AsteroidSprite.SizeState.Small, level: 0);
                    s.position = parentAsteroid!.position;
                    break
                default: // the parent was too small, so bail out and don't make more asteroids
                    return;
                }
            }
            
            s.name = "asteroid";
            
            // eventually swap this with a random vector closer in direction to the direction of the parent asteroid
            s.fwd = CGPoint.randomUnitVector();
            addChild(s);
        }
    }
    
    // calculate the time between frames
    func calculateDeltaTime(currentTime: TimeInterval) {
        if (lastUpdateTime > 0){
            dt = currentTime - lastUpdateTime;
        } else {
            dt = 0;
        }
        lastUpdateTime = currentTime;
    }
    
    // during update move the asteroids and check for collisions
    func moveSpritesAndCheckCollisions(dt:CGFloat) {
        
        // only move when the sprites aren't paused
        if (spritesMoving) {
            
            // find all the asteroids
            enumerateChildNodes(withName: "asteroid", using: {
                node, stop in
                
                // grab the asteroid
                let s = node as! AsteroidSprite
                
                // update the asteroid
                s.update(dt: dt);
                
                // handle if the asteroid is colliding with the ship
                if s.isColliding(position: self.ship!.position, radius: self.ship!.radius) {
                    self.makeAsteroidSprite(howMany: 2, parentAsteroid: s)
                    
                    self.levelScore += s.getPointValue();
                    
                    node.removeFromParent()
                }
            })
        }
    }
    
    // unpause sprites at the beginning of the game after a few seconds
    func unpauseSprites() {
        let unpauseAction = SKAction.sequence([
            SKAction.wait(forDuration: 2),
            SKAction.run({self.spritesMoving = true})
            ]);
        run(unpauseAction);
    }
    
    // MARK: - Events -
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        tapCount = tapCount + 1;
        if(tapCount < 3) {
            return;
        }
        
        
        //let results = LevelResults(msg: "Game Over");
        //sceneManager.loadGameOverScene(results: results);
        
    }
    
    // MARK: - Game Loop
    
    override func update(_ currentTime: TimeInterval){
        calculateDeltaTime(currentTime: currentTime);
        moveSpritesAndCheckCollisions(dt: CGFloat(dt));
        ship?.update(dt: CGFloat(dt))
    }
}
