//
//  config.swift
//  TrampolineJumpSwift
//
//  Created by App Developer on 14/02/2015.
//  Copyright (c) 2015 App Developer. All rights reserved.
//

import Foundation

struct config {
    
    static var LeaderboardID = "TrampolineMonstersLeaderBoard"
    static var iapProductID = "trampolineMonstersUnlock";

    static let gameFont = "AppleSDGothicNeo-Bold"
    static let heightMarkerText = "-----------THE END------------"
    static let perfectJumpText = "PERFECT JUMP!"
    static let perfectJumpMultiplyerValue = CGFloat(300)
    static let initialImpulse = CGFloat(50.0)
    static let worldGravity = -2.0
    static let playerStartY = CGFloat(80.0)
    
    static let badVelocity = CGFloat(300)
    static let startVelocity = CGFloat(450)
    static var currentVelocity = CGFloat(400.0)
    
    
    static var starIsEvil = false
    static var characterCount: Int = 2

}