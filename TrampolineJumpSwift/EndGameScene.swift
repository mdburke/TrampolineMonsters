//
//  EndGameScene.swift
//  TrampolineJumpSwift
//
//  Created by App Developer on 11/02/2015.
//  Copyright (c) 2015 App Developer. All rights reserved.
//

import SpriteKit

class EndGameScene: SKScene {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    let restartButt = SKSpriteNode(imageNamed: "btnRestart")
    let quitButt = SKSpriteNode(imageNamed: "btnQuit")

    
    override init(size: CGSize) {
        super.init(size: size)
        
        
        //Ads
        //AppDelegate.showChartboostAds()
        
        let gameFont = "AppleSDGothicNeo-Bold"
        
        let star = SKSpriteNode(imageNamed: "lblAllRot")
        star.position = CGPoint(x: 25, y: self.size.height-30)
        addChild(star)
        
        let lblStars = SKLabelNode(fontNamed: gameFont)
        lblStars.fontSize = 30
        lblStars.fontColor = SKColor.whiteColor()
        lblStars.position = CGPoint(x: 50, y: self.size.height-40)
        lblStars.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        lblStars.text = String(format: "X %d", GameState.sharedInstance.allFlip)
        addChild(lblStars)
        
        let lblScore = SKLabelNode(fontNamed: gameFont)
        lblScore.fontSize = 40
        lblScore.fontColor = SKColor.whiteColor()
        lblScore.position = CGPoint(x: self.size.width / 2, y: 300)
        lblScore.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        lblScore.text = String(format: "Score: %d", GameState.sharedInstance.score)
        addChild(lblScore)
        
        quitButt.position = CGPoint(x: self.size.width / 2, y: 380)
        restartButt.position = CGPoint(x: self.size.width / 2, y: (quitButt.size.height) + (quitButt.position.y + 20))
        
        addChild(quitButt)
        addChild(restartButt)

        
        let lblHighScore = SKLabelNode(fontNamed: gameFont)
        lblHighScore.fontSize = 30
        lblHighScore.fontColor = SKColor.whiteColor()
        lblHighScore.position = CGPoint(x: self.size.width / 2, y: 150)
        lblHighScore.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        lblHighScore.text = String(format: "High Score: %d", GameState.sharedInstance.highScore)
        addChild(lblHighScore)
        
        let lblTryAgain = SKLabelNode(fontNamed: gameFont)
        lblTryAgain.fontSize = 30
        lblTryAgain.fontColor = SKColor.redColor()
        lblTryAgain.position = CGPoint(x: self.size.width / 2, y: 50)
        lblTryAgain.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        lblTryAgain.text = "GAME OVER"
        addChild(lblTryAgain)
        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
      
        for touch: AnyObject in touches {
            
            let location = touch.locationInNode(self)

        if restartButt.containsPoint(location){
            
            let reveal = SKTransition.fadeWithDuration(0.5)
            let gameScene = GameScene(size: self.size)
            self.view!.presentScene(gameScene, transition: reveal)
            
            
        }else if quitButt.containsPoint(location){

            
            let reveal = SKTransition.fadeWithDuration(0.5)
            let titleScene = TitleScene(size: self.size)
            self.view!.presentScene(titleScene, transition: reveal)
        }

        }
}
    
}
