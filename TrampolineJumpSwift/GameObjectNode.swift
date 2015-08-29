//
//  GameObjectNode.swift
//  TrampolineJumpSwift
//
//  Created by App Developer on 11/02/2015.
//  Copyright (c) 2015 App Developer. All rights reserved.
//

import SpriteKit

struct CollisionCategoryBitmask {
    static let Player: UInt32 = 0x00
    static let Star: UInt32 = 0x01
    static let Platform: UInt32 = 0x02
}

enum PlatformType: Int {
    case Normal = 0
    case Break
}

enum StarType: Int {
    case Normal = 0
    case Special
}

class GameObjectNode: SKNode {
    
    func collisionWithPlayer(player: SKNode) -> Bool {
        return false
    }
    
}

class PlatformNode: GameObjectNode {
    var platformType: PlatformType!
    var platCollide = false
    let TrampolineSound = SKAction.playSoundFileNamed("TrampolineSound.wav", waitForCompletion: false)
    
    override func collisionWithPlayer(player: SKNode) -> Bool {
        
        if volumeOn == true {
            runAction(TrampolineSound, completion: {
                
                
            })
        }
        
        if player.physicsBody?.velocity.dy < 0 {
            // 2
            player.physicsBody?.velocity = CGVector(dx: player.physicsBody!.velocity.dx, dy: 650.0)
            
        }
        
        return false
    }
}

class StarNode: GameObjectNode {
    var starType: StarType!
    let starSound = SKAction.playSoundFileNamed("StarSound.wav", waitForCompletion: false)
    
    override func collisionWithPlayer(player: SKNode) -> Bool {

        if player.physicsBody?.velocity.dy < 400 {
            
            player.physicsBody?.velocity.dy = 400
            
        } else {
            
            player.physicsBody?.velocity = CGVector(dx: player.physicsBody!.velocity.dx, dy: player.physicsBody!.velocity.dy + 10)
            
        }
        
        if volumeOn == true {
            runAction(starSound, completion: {
                
                self.removeFromParent()

            })
        } else {
            
            self.removeFromParent()
            
        }


        
        return true
    }
}
