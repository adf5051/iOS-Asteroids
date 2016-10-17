//
//  GameData.swift
//  Asteroids
//
//  Created by jefferson on 9/15/16.
//  Copyright © 2016 tony. All rights reserved.
//

import SpriteKit

struct GameData{
    init(){
        fatalError("The GameData struct is a singleton")
    }
    
    static let debugMode = true
    
    static let maxLevel = 3
    struct font{
        static let mainFont = "Futura-MediumItalic"
    }
    
    struct hud{
        static let backgroundColor = SKColor.black
        static let fontSize = CGFloat(64.0)
        static let smallFont = CGFloat(32.0)
        static let fontColorWhite = SKColor(red: 0.90, green: 0.90, blue: 0.90, alpha: 1.0)
        static let marginV = CGFloat(12.0)
        static let marginH = CGFloat(12.0)
        static let shipMaxSpeedPerSecond = CGFloat(800.0)
    }
    
    struct image{
        static let startScreenLogo = "alien_top_01"
        static let background = "background"
        static let player_A = "spaceflier_01_a"
        static let player_B = "spaceflier_01_b"
        static let arrow = "arrow"
    }
    
    struct scene {
        static let backgroundColor = SKColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
    }
}

