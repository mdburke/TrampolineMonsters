//
//  TitleScene.swift
//  TrampolineJumpSwift
//
//  Created by App Developer on 11/02/2015.
//  Copyright (c) 2015 App Developer. All rights reserved.
//

import SpriteKit

var volumeOn = true

class TitleScene: SKScene {
    
    var backgroundNode = SKNode()
    var foregroundNode = SKNode()
    
    
    // Scale Factor
    var scaleFactor: CGFloat = 0.0
    
    //Scene Buttons
    let startButt = SKSpriteNode(imageNamed: "btnStart")
    let upgradeButt = SKSpriteNode(imageNamed: "btnUnlock")
    let restoreButt = SKSpriteNode(imageNamed: "btnRestore")
    let gameCenterButt = SKSpriteNode(imageNamed: "btnGC")
    let overlayButt = SKSpriteNode(imageNamed: "lockedOverlaythumb")
    let volumeButt = SKSpriteNode(imageNamed: "SoundOn")
    
    // Logo
    let logoImage = SKSpriteNode(imageNamed: "Logo")
    
    // Get Screen Size
    var xheight = UIScreen.mainScreen().applicationFrame.size.height
    var xwidth = UIScreen.mainScreen().applicationFrame.size.width
    
    //char select
    var pCount: Int = 0
    let goLeft = SKSpriteNode(imageNamed: "btnRotLeft")
    let goRight = SKSpriteNode(imageNamed: "btnRotRight")
    var charImage = SKSpriteNode(imageNamed: "Player00")
    var unlocked = false

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        // Background
        backgroundColor = SKColor.blackColor()
        scaleFactor = self.size.width / 320.0
        backgroundNode = createBackgroundNode()
        backgroundNode.position = CGPoint(x: 0.0, y: 0.0)
        addChild(backgroundNode)
        
        //Foreground
        foregroundNode = SKNode()
        addChild(foregroundNode)
        
        //Buttons
        var spacer = xheight / startButt.size.height

        if let volumeOn = defaults.valueForKey("volumeOn") as? Bool {
        
            if volumeOn == true {
                
                volumeButt.texture = SKTexture(imageNamed: "SoundOn")
                
            } else {
                
                volumeButt.texture = SKTexture(imageNamed: "SoundOff")
                
            }
        }
        
        gameCenterButt.position = CGPoint(x: xwidth/2, y: 40)
        restoreButt.position = CGPoint(x: xwidth/2, y: (restoreButt.size.height) + (gameCenterButt.position.y + spacer))
        upgradeButt.position = CGPoint(x: xwidth/2, y: (upgradeButt.size.height) + (restoreButt.position.y + spacer))
        startButt.position = CGPoint(x:xwidth/2, y: (startButt.size.height) + (upgradeButt.position.y + spacer))
        logoImage.position = CGPoint(x: xwidth/2, y: self.size.height - (self.size.height / 8))
        logoImage.size = CGSize(width: xwidth, height: xheight/6)
        volumeButt.position = CGPoint(x: (gameCenterButt.position.x - gameCenterButt.size.width/2) / 2, y: gameCenterButt.position.y)
        volumeButt.size.height = self.size.width/7
        volumeButt.size.width = self.size.width/7
        
        
        foregroundNode.addChild(volumeButt)
        foregroundNode.addChild(logoImage)
        foregroundNode.addChild(gameCenterButt)
        foregroundNode.addChild(restoreButt)
        foregroundNode.addChild(upgradeButt)
        foregroundNode.addChild(startButt)
        
        //char select
        
        
        goLeft.position = CGPoint(x:goLeft.size.width/2, y: logoImage.position.y - 80)
        goRight.position = CGPoint(x: xwidth - goLeft.size.width/2, y: goLeft.position.y)
        charImage.position = CGPoint(x: self.size.width/2, y: goLeft.position.y)
        
        foregroundNode.addChild(goLeft)
        foregroundNode.addChild(goRight)
        foregroundNode.addChild(charImage)
        
        
        unlocked = defaults.boolForKey("unlockedKey")

        
    }
    
    
    func charLeft(){
        println("CHAR: \(pCount)")
        
        if pCount == 0{
            
            pCount = 2
            
        }else{
            
           pCount--
        }

        
        changeChar()
    }
    
    func charRight(){
        println("CHAR: \(pCount)")
        
        if pCount == config.characterCount{
            
            pCount = 0
            
        }else{
            
            pCount++
        }

        
        changeChar()
    }
    
    func changeChar(){
        
        
        
        println("image: \(pCount)")
            charImage.removeFromParent()
            charImage = SKSpriteNode(imageNamed:String(format: "Player%02d", pCount))
            charImage.position = CGPoint(x: self.size.width/2, y: goLeft.position.y)
            foregroundNode.addChild(charImage)
        
        
        if !unlocked &&  pCount != 0 {
            
            println("UNLOCKED: \(unlocked)")
            charImage.addChild(overlayButt)
            
            let defaults = NSUserDefaults.standardUserDefaults()
            //defaults.setObject(pCount, forKey: "playerChoice")
            defaults.setInteger(0, forKey: "playerChoice")
            
        }else{
            
            let defaults = NSUserDefaults.standardUserDefaults()
            //defaults.setObject(pCount, forKey: "playerChoice")
            defaults.setInteger(pCount, forKey: "playerChoice")
        }

    }

    
    func createBackgroundNode() -> SKNode {
        
        let backgroundNode = SKNode()
        let ySpacing = 64.0 * scaleFactor
        
//        for index in 0...19 {
//            
//            let node = SKSpriteNode(imageNamed:String(format: "Background%02d", index + 1))
//            node.setScale(scaleFactor)
//            node.anchorPoint = CGPoint(x: 0.5, y: 0.0)
//            node.position = CGPoint(x: self.size.width / 2, y: ySpacing * CGFloat(index))
//            backgroundNode.addChild(node)
//        }
        
        let node = SKSpriteNode(imageNamed: String(format: "house"))
        node.setScale(scaleFactor/2)
        node.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        node.position = CGPoint(x: self.size.width / 2, y: 0)
        backgroundNode.addChild(node)
        return backgroundNode
    }
    
    func volumeButton() {
        
        if volumeOn == true {
            
            volumeOn = false
            volumeButt.texture = SKTexture(imageNamed: "SoundOff")
            
        } else if volumeOn == false {
            
            volumeOn = true
            volumeButt.texture = SKTexture(imageNamed: "SoundOn")
            
        }
        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            
            let location = touch.locationInNode(self)
            
            if startButt.containsPoint(location) {
                
                let reveal = SKTransition.fadeWithDuration(0.5)
                let gameScene = GameScene(size: self.size)
                self.view!.presentScene(gameScene, transition: reveal)

                
            }else if upgradeButt.containsPoint(location) {
                
                let defaults = NSUserDefaults.standardUserDefaults()
                var unlocked = defaults.boolForKey("unlockedKey")
                if !unlocked {
                    
                    FunkyPiDevIAP.sharedInstance.buyIAP()
                    
                } else {
                    
                    
                    
                }
                    
            }else if gameCenterButt.containsPoint(location){
                
                var vc = self.view?.window?.rootViewController
        
                GCHelper.sharedInstance.showGameCenter(vc!, viewState: .Achievements)

    
            }else if restoreButt.containsPoint(location){
                
                FunkyPiDevIAP.sharedInstance.restoreIAP()
                
            }else if goLeft.containsPoint(location){
                
                charLeft()
                
            }else if goRight.containsPoint(location){
                
                charRight()
                
            }else if charImage.containsPoint(location){
                
                FunkyPiDevIAP.sharedInstance.buyIAP()
                
            } else if volumeButt.containsPoint(location){
                
                volumeButton()
                
            }
                
                
                
            }

        }
    }
    

