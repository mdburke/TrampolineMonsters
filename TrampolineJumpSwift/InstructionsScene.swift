//
//  InstructionsScene.swift
//  TrampolineJumpSwift
//
//  Created by Michael Burke on 8/29/15.
//  Copyright (c) 2015 App Developer. All rights reserved.
//

import SpriteKit

class InstructionsScene: SKScene {
    
    var turnOffButton = SKSpriteNode()
    var backBackground = SKSpriteNode()
    var background = SKSpriteNode()
    var titleLabel = SKLabelNode()
    var scaleFactor: CGFloat = 0.0
    var instructionLabel = SKLabelNode()
    var instructionLabel2 = SKLabelNode()
    var instructionLabel3 = SKLabelNode()
    var instructionLabel4 = SKLabelNode()
    var instructionLabel5 = SKLabelNode()
    var instructionLabel6 = SKLabelNode()
    var instructionLabel7 = SKLabelNode()
    var instructionLabel8 = SKLabelNode()
    var instructionLabel9 = SKLabelNode()
    var instructionLabel10 = SKLabelNode()
    var instructionLabel11 = SKLabelNode()
    var instructionLabel12 = SKLabelNode()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        scaleFactor = self.size.width / 60
        
        backBackground.texture = SKTexture(imageNamed: "Background")
        backBackground.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        backBackground.size = CGSize(width: self.size.width, height: self.size.height)
        backBackground.setScale(scaleFactor/2)
        backBackground.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        backBackground.zPosition = -1
        self.addChild(backBackground)
        
        background.texture = SKTexture(imageNamed: "2.jpg")
        background.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        background.size = CGSize(width: self.size.width, height: self.size.height)
        background.zPosition = 0
        background.alpha = 0.8
        self.addChild(background)
        
        titleLabel.position = CGPoint(x: self.frame.midX, y: self.frame.maxY - 50)
        //titleLabel.size = CGSize(width: self.size.width / 2, height: 50)
        titleLabel.fontSize = 28
        titleLabel.fontColor = SKColor.blackColor()
        titleLabel.text = "How To Play!"
        titleLabel.zPosition = 50
        titleLabel.fontName = config.gameFont
        self.addChild(titleLabel)
        
        instructionLabel.position = CGPoint(x: self.frame.midX, y: titleLabel.position.y - 60)
        instructionLabel.fontSize = 23
        instructionLabel.fontColor = SKColor.blackColor()
        instructionLabel.text = "Try to get all the stars before you"
        self.addChild(instructionLabel)
        
        instructionLabel2.position = CGPoint(x: self.frame.midX, y: instructionLabel.position.y - 30)
        instructionLabel2.fontSize = 23
        instructionLabel2.fontColor = SKColor.blackColor()
        instructionLabel2.text = "reach the top!"
        self.addChild(instructionLabel2)
        
        instructionLabel3.position = CGPoint(x: self.frame.midX, y: instructionLabel2.position.y - 60)
        instructionLabel3.fontSize = 23
        instructionLabel3.fontColor = SKColor.blackColor()
        instructionLabel3.text = "More stars = more points!"
        self.addChild(instructionLabel3)
        
        instructionLabel6.position = CGPoint(x: self.frame.midX, y: instructionLabel3.position.y - 30)
        instructionLabel6.fontSize = 23
        instructionLabel6.fontColor = SKColor.blackColor()
        instructionLabel6.text = "More spins = more points!"
        self.addChild(instructionLabel6)
        
        instructionLabel7.position = CGPoint(x: self.frame.midX, y: instructionLabel6.position.y - 30)
        instructionLabel7.fontSize = 23
        instructionLabel7.fontColor = SKColor.blackColor()
        instructionLabel7.text = "Perfect Jumps on the trampoline"
        self.addChild(instructionLabel7)
        
        instructionLabel8.position = CGPoint(x: self.frame.midX, y: instructionLabel7.position.y - 30)
        instructionLabel8.fontSize = 23
        instructionLabel8.fontColor = SKColor.blackColor()
        instructionLabel8.text = " = more points!"
        self.addChild(instructionLabel8)
        
        instructionLabel4.position = CGPoint(x: self.frame.midX, y: instructionLabel8.position.y - 40)
        instructionLabel4.fontSize = 23
        instructionLabel4.fontColor = SKColor.blackColor()
        instructionLabel4.text = "Spin right to go up!"
        self.addChild(instructionLabel4)
        
        instructionLabel5.position = CGPoint(x: self.frame.midX, y: instructionLabel4.position.y - 40)
        instructionLabel5.fontSize = 23
        instructionLabel5.fontColor = SKColor.blackColor()
        instructionLabel5.text = "Spin left to go down!"
        self.addChild(instructionLabel5)
        
        instructionLabel10.position = CGPoint(x: self.frame.midX, y: instructionLabel5.position.y - 40)
        instructionLabel10.fontSize = 23
        instructionLabel10.fontColor = SKColor.blackColor()
        instructionLabel10.text = "More spins = higher jumps"
        self.addChild(instructionLabel10)
        
        instructionLabel9.position = CGPoint(x: self.frame.midX, y: instructionLabel10.position.y - 60)
        instructionLabel9.fontSize = 23
        instructionLabel9.fontColor = SKColor.redColor()
        instructionLabel9.fontName = config.gameFont
        instructionLabel9.text = "DON'T HIT THE RED STARS!"
        self.addChild(instructionLabel9)
        
        instructionLabel11.position = CGPoint(x: self.frame.midX, y: instructionLabel9.position.y - 40)
        instructionLabel11.fontSize = 23
        instructionLabel11.fontColor = SKColor.redColor()
        instructionLabel11.fontName = config.gameFont
        instructionLabel11.text = "LET GO BEFORE YOU"
        self.addChild(instructionLabel11)
        
        instructionLabel12.position = CGPoint(x: self.frame.midX, y: instructionLabel11.position.y - 25)
        instructionLabel12.fontSize = 23
        instructionLabel12.fontColor = SKColor.redColor()
        instructionLabel12.fontName = config.gameFont
        instructionLabel12.text = "HIT THE TRAMPOLINE!"
        self.addChild(instructionLabel12)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        defaults.setBool(false, forKey: "instructionsOn")    
    }
    
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        let reveal = SKTransition.fadeWithDuration(0.5)
        let gameScene = GameScene(size: self.size)
        self.view!.presentScene(gameScene, transition: reveal)
    }
}
