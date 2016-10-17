//
//  GameViewController.swift
//  Asteroids
//
//  Created by Alex Fuerst on 9/26/16.
//  Original Author: Tony Jefferson
//

import UIKit
import SpriteKit
import GameplayKit

// The main game view controller
class GameViewController: UIViewController {

    // MARK: - ivars -
    
    // main game scene
    var gameScene: GameScene?;
    
    // the main spriekit view
    var skView:SKView!;
    
    // the screen size (iphone resolution)
    let screenSize = CGSize(width:1080, height:1920);
    
    // the scalemode for spritekit
    let scaleMode = SKSceneScaleMode.aspectFill;
    
    // the view has loaded
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // reference this view as skview
        skView = self.view as! SKView
        
        // fire up the intro screen
        loadHomeScene();
        
        skView.ignoresSiblingOrder = true;
        skView.showsFPS = GameData.debugMode;
        skView.showsNodeCount = GameData.debugMode;
        
        self.becomeFirstResponder()
    }
    
    // load the intro screen
    func loadHomeScene() {
        let scene = HomeScreen(size:screenSize, scaleMode:scaleMode, sceneManager: self);
        let reveal = SKTransition.crossFade(withDuration: 1);
        skView.presentScene(scene, transition: reveal);
    }
    
    // load the main game screen
    func loadGameScene() {
        gameScene = GameScene(size:screenSize, scaleMode: scaleMode, sceneManager: self);
        let reveal = SKTransition.doorsOpenHorizontal(withDuration: 1);
        skView.presentScene(gameScene!, transition: reveal);
        MotionMonitor.sharedMotionMonitor.startUpdates()
    }
    
    // load the level screen
    func loadLevelFinishScene(results:LevelResults) {
        gameScene = nil;
        let scene = LevelFinishScene(size: screenSize, scaleMode: scaleMode, results: results, sceneManager: self);
        let reveal = SKTransition.crossFade(withDuration: 1);
        skView.presentScene(scene,transition:reveal);
        
        MotionMonitor.sharedMotionMonitor.stopUpdates()
    }
    
    // load the game over screen
    func loadGameOverScene() {
        gameScene = nil;
        let scene = GameOverScene(size: screenSize, scaleMode: scaleMode, sceneManager: self);
        let reveal = SKTransition.crossFade(withDuration: 1);
        skView.presentScene(scene, transition: reveal);
    }
    
    func loadHelpScene() {
        gameScene = nil;
        let scene = HelpScene(size: screenSize, scaleMode: scaleMode, sceneManager: self)
        let reveal = SKTransition.doorsCloseVertical(withDuration: 1)
        skView.presentScene(scene, transition: reveal)
    }
    
    // prevent autorotation of screen
    override var shouldAutorotate: Bool {
        return false;
    }

    // allow only portrait orientation
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    // hide the status bar
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // let this app be the first responder for input and gestures
    override var canBecomeFirstResponder: Bool {
        return true
    }
}
