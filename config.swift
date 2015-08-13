//
//  config.swift
//  TrampolineJumpSwift
//
//  Created by App Developer on 14/02/2015.
//  Copyright (c) 2015 App Developer. All rights reserved.
//

import Foundation

struct config {
    
    static var LeaderboardID = "bouncingBabyHighScore"
    static var iapProductID = "bouncingBabyUnlock";

    static let gameFont = "AppleSDGothicNeo-Bold"
    static let heightMarkerText = "---------RECORD HEIGHT-----------"
    static let perfectJumpText = "PERFECT JUMP!"
    static let perfectJumpMultiplyerValue = CGFloat(200)
    static let initialImpulse = CGFloat(40.0)
    static let worldGravity = -2.0
    static let playerStartY = CGFloat(80.0)
    
    static let badVelocity = CGFloat(500)
    static let startVelocity = CGFloat(650)
    static var currentVelocity = CGFloat(650.0)
    
    
    static var starIsEvil = false
    static var characterCount: Int = 2

}