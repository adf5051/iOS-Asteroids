//
//  LevelResults.swift
//  Shooter1
//
//  Created by Alex Fuerst on 9/26/16.
//

import Foundation

class LevelResults {
    let levelNum:Int;
    let levelScore:Int;
    let totalScore:Int;
    let msg:String;
    
    init(levelNum:Int, levelScore:Int, totalScore:Int, msg:String) {
        self.levelScore = levelScore;
        self.levelNum = levelNum;
        self.totalScore = totalScore;
        self.msg = msg;
    }
}
