//
//  GameState.swift
//  TrampolineJumpSwift
//
//  Created by App Developer on 11/02/2015.
//  Copyright (c) 2015 App Developer. All rights reserved.
//


import Foundation

class GameState {
    
    var score: Int
    var highScore: Int
    var allFlip: Int

    class var sharedInstance :GameState {
        struct Singleton {
            static let instance = GameState()
        }
        
        return Singleton.instance
    }
    
    init() {
        score = 0
        highScore = 0
        allFlip = 0

        let defaults = NSUserDefaults.standardUserDefaults()
        
        highScore = defaults.integerForKey("highScore")
        allFlip = defaults.integerForKey("allFlip")
    }
    
    func saveState() {

        highScore = max(score, highScore)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(highScore, forKey: "highScore")
        defaults.setInteger(allFlip, forKey: "allFlip")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
}

