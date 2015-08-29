//
//  GameScene.swift
//  TrampolineJumpSwift
//
//  Created by App Developer on 11/02/2015.
//  Copyright (c) 2015 App Developer. All rights reserved.
//

import SpriteKit
import CoreMotion
import GameKit
import AVFoundation

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var selectedNodes:[UITouch:SKSpriteNode] = [UITouch:SKSpriteNode]()
    var spinRightStart = SKAction.rotateByAngle(CGFloat(-M_PI/12.0), duration: NSTimeInterval(0.1))
    var spinLeftStart = SKAction.rotateByAngle(CGFloat(M_PI/12.0), duration: NSTimeInterval(0.1))
    var starsConsumed = 0
    var perfectJumpCount = 0
    var heightMarkery:CGFloat = 0
    var starsTotal = 0
    var jumpsInARow = 0
    var starsTemp = 0
    var perfectJumpFloat = CGFloat(0.0)
    
    
    // Layer Nodes
    var backgroundNode = SKNode()
    var midgroundNode = SKNode()
    var foregroundNode = SKNode()
    var hudNode = SKNode()
    var pauseNode = SKNode()
    
    
    // Player
    var player = SKNode()
    
    // Start Button
    var tapToStartNode = SKSpriteNode(imageNamed: "btnstartJump")
    
    //Rotate Buttons
    let rotateLeft = SKSpriteNode(imageNamed: "btnRotLeft")

    let rotateRight = SKSpriteNode(imageNamed: "btnRotRight")

    
    //Pause Button and BG
    let btnPause = SKSpriteNode(imageNamed: "btnPause")
    let resumeButt = SKSpriteNode(imageNamed: "btnResume")
    let quitButt = SKSpriteNode(imageNamed: "btnQuit")
    
    // Timers
    var timerRight = NSTimer()
    var timerLeft = NSTimer()
    var counterRight = 0
    var counterLeft = 0
    
    // Booleans
    var buttonOnCollision = false
    var spinningLeft = false
    var spinningRight = false
    var gameOver = false
    var platformCollide = false
    var gamePaused = false
    // Angles and Velocities
    var perfectJumpMultiplyer = CGFloat(0.0)
    
    var newVelocity = CGFloat(0.0)
    var radToDeg = CGFloat(0.0)
    
    //Rotation Counts
    var totalRotationsSlowFF = 0
    var totalRotationsMediumFF = 0
    var totalRotationsFastFF = 0
    var totalRotationsSlowBF = 0
    var totalRotationsMediumBF = 0
    var totalRotationsFastBF = 0
    var intermediateFF = 0
    var intermediateBF = 0
    var allRotations = 0
    var countRotSilent = 0
    var jumpCount = 0
    var isRotatingRight = false
    var isRotatingLeft = false
    var currentNode:SKSpriteNode?
    
    // Accelerometer
    let motionManager = CMMotionManager()
    var xAcceleration: CGFloat = 0.0
    
    // On Screen Labels
    var lblScore: SKLabelNode = SKLabelNode()
    var lblHeight: SKLabelNode = SKLabelNode()
    var lblFF: SKLabelNode = SKLabelNode()
    var lblBF: SKLabelNode = SKLabelNode()
    var lblAllFlips: SKLabelNode = SKLabelNode()
    var lblFlipType: SKLabelNode = SKLabelNode()
    var lblMaxJumpHeightMarker: SKLabelNode = SKLabelNode()
    
    
    // Coordinate of Top of Screen
    let endLevelY = 8000
    var maxPlayerY = 80 //iason

    // Get Screen Size
    var xheight = UIScreen.mainScreen().applicationFrame.size.height
    var xwidth = UIScreen.mainScreen().applicationFrame.size.width
    
    
    
    // Scale Factor
    var scaleFactor: CGFloat = 0.0
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        backgroundColor = SKColor.blackColor()
        scaleFactor = self.size.width / 320.0
        
        
        // Reset
        GameState.sharedInstance.score = 0
        gameOver = false
        
        // Background
        backgroundNode = createBackgroundNode()
        addChild(backgroundNode)
        
        /*
        // Midground
        midgroundNode = createMidgroundNode()
        addChild(midgroundNode)
        */
        
        // Gravity
        physicsWorld.gravity = CGVector(dx: 0.0, dy: config.worldGravity)
        
        // Collision
        physicsWorld.contactDelegate = self
        
        // Foreground
        foregroundNode = SKNode()
        addChild(foregroundNode)
        
        // Pause Node
        pauseNode = SKNode()
        addChild(pauseNode)
        
        // HUD
        hudNode = SKNode()
        addChild(hudNode)
        
        // Load Level
        let levelPlist = NSBundle.mainBundle().pathForResource("levelSetup", ofType: "plist")
        let levelData = NSDictionary(contentsOfFile: levelPlist!)!
        
        
        // Add the platforms
        let platform = createPlatformAtPosition(CGPoint(x: xwidth/2, y: 200), ofType: .Normal)
        //let platform2 = createPlatformAtPosition(CGPoint(x: xwidth/2, y: 2000), ofType: .Normal)
        foregroundNode.addChild(platform)
       // foregroundNode.addChild(platform2)
    
        // Add the stars
        let stars = levelData["Stars"] as! NSDictionary
        let starPatterns = stars["Patterns"] as! NSDictionary
        let starPositions = stars["Positions"] as! [NSDictionary]
        
        for starPosition in starPositions {
            let patternX = starPosition["x"]?.floatValue
            let patternY = starPosition["y"]?.floatValue
            let pattern = starPosition["pattern"] as! NSString
            
            // Look up the pattern
            let starPattern = starPatterns[pattern] as! [NSDictionary]
            for starPoint in starPattern {
                let x = starPoint["x"]?.floatValue
                let y = starPoint["y"]?.floatValue
                let type = StarType(rawValue: starPoint["type"]!.integerValue)
                let positionX = CGFloat(x! + patternX!)
                let positionY = CGFloat(y! + patternY!)
                let starNode = createStarAtPosition(CGPoint(x: positionX, y: positionY), ofType: type!)
                foregroundNode.addChild(starNode)
            }
        }
        
        // Add the player
        player = createPlayer()
        foregroundNode.addChild(player)
        
        // Tap to Start
        tapToStartNode = SKSpriteNode(imageNamed: "btnstartJump")
        tapToStartNode.position = CGPoint(x: self.size.width / 2, y: config.playerStartY)
        hudNode.addChild(tapToStartNode)
        
        // Build the HUD
        //Highest Jump Line
        let getHighestJump = String(format: "Highest Jump: %d", GameState.sharedInstance.recordHeight)
        let getHighestJumpInt:Int? = getHighestJump.toInt()
        heightMarkery = CGFloat(GameState.sharedInstance.recordHeight)
        lblMaxJumpHeightMarker = SKLabelNode(fontNamed: config.gameFont)
        lblMaxJumpHeightMarker.fontSize = 30
        lblMaxJumpHeightMarker.fontColor = SKColor.whiteColor()
        lblMaxJumpHeightMarker.position = CGPoint(x: CGFloat(xwidth/2), y: CGFloat(endLevelY))
        lblMaxJumpHeightMarker.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        lblMaxJumpHeightMarker.text = config.heightMarkerText
        foregroundNode.addChild(lblMaxJumpHeightMarker)
        
        //Flip Quality Text
        lblFlipType = SKLabelNode(fontNamed: config.gameFont)
        lblFlipType.fontSize = 30
        lblFlipType.fontColor = SKColor.whiteColor()
        lblFlipType.position = CGPoint(x: xwidth/2, y: xheight/2)
        lblFlipType.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        lblFlipType.alpha = 0.0
        lblFlipType.text = config.perfectJumpText
        hudNode.addChild(lblFlipType)
        
        // FrontFlip
        let ffImage = SKSpriteNode(imageNamed: "lblRotRight")
        ffImage.position = CGPoint(x: 25, y: self.size.height-30)
        hudNode.addChild(ffImage)
        lblFF = SKLabelNode(fontNamed: config.gameFont)
        lblFF.fontSize = 30
        lblFF.fontColor = SKColor.whiteColor()
        lblFF.position = CGPoint(x: 50, y: self.size.height-40)
        lblFF.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        lblFF.text = "0"
        hudNode.addChild(lblFF)
        
        // BackFlip
        let bfImage = SKSpriteNode(imageNamed: "lblRotLeft")
        bfImage.position = CGPoint(x: 25, y: ffImage.position.y - 40.0)
        hudNode.addChild(bfImage)
        lblBF = SKLabelNode(fontNamed: config.gameFont)
        lblBF.fontSize = 30
        lblBF.fontColor = SKColor.whiteColor()
        lblBF.position = CGPoint(x: 50, y: lblFF.position.y - 40.0)
        lblBF.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        lblBF.text = "0"
        hudNode.addChild(lblBF)
        
        // Height
//        lblHeight = SKLabelNode(fontNamed: config.gameFont)
//        lblHeight.fontSize = 30
//        lblHeight.fontColor = SKColor.whiteColor()
//        lblHeight.position = CGPoint(x: self.size.width-20, y: 40)
//        lblHeight.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Right
//        lblHeight.text = "0"
//        hudNode.addChild(lblHeight)

        // Score
        lblScore = SKLabelNode(fontNamed: config.gameFont)
        lblScore.fontSize = 30
        lblScore.fontColor = SKColor.whiteColor()
        lblScore.position = CGPoint(x: self.size.width-20, y: self.size.height-40)
        lblScore.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Right
        lblScore.text = "0"
        hudNode.addChild(lblScore)

        // Flips
        lblAllFlips = SKLabelNode(fontNamed: config.gameFont)
        lblAllFlips.fontSize = 30
        lblAllFlips.fontColor = SKColor.whiteColor()
        lblAllFlips.position = CGPoint(x: self.size.width-40, y: lblScore.position.y - 40)
        lblAllFlips.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        lblAllFlips.text = "0 "
        hudNode.addChild(lblAllFlips)

        
        // Accelerometer
        motionManager.accelerometerUpdateInterval = 0.2
        motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.currentQueue(), withHandler: {
            (accelerometerData: CMAccelerometerData!, error: NSError!) in
            let acceleration = accelerometerData.acceleration
            self.xAcceleration = (CGFloat(acceleration.x) * 0.75) + (self.xAcceleration * 0.25)
        })
        
       
        
    }

    // MARK: didMoveToView
    override func didMoveToView(view: SKView) {
    
        player.physicsBody?.velocity = CGVector(dx: player.physicsBody!.velocity.dx, dy:config.startVelocity)
        config.currentVelocity = config.startVelocity
        jumpCount = 0
        
    }
   
    // MARK: Update Counters

    func updateCounterRight() {
        
        counterRight++
        isRotatingLeft = false
        var counterFloat = CGFloat(counterRight) * -0.1;
        buttonOnCollision = true
        
        if counterFloat >= -2 {
            
            var spinRight = SKAction.rotateByAngle(CGFloat(-M_PI/10.0), duration: NSTimeInterval(0.1))
            player.runAction(spinRight)
            
            
        } else if counterFloat >= -4 && counterFloat < -2 {
        
            var spinRight = SKAction.rotateByAngle(CGFloat(-M_PI/5.0), duration: NSTimeInterval(0.1))
            player.runAction(spinRight)
        
        } else {
    
            var spinRight = SKAction.rotateByAngle(CGFloat(-M_PI/2.5), duration: NSTimeInterval(0.1))
            player.runAction(spinRight)
        }
        
        if counterRight <= 20 {
            
            totalRotationsSlowFF = (counterRight/20)

        } else if counterRight <= 40 && counterRight > 20 {
            
            totalRotationsMediumFF = (counterRight - 20)/10
        
        } else {
            
            totalRotationsFastFF = (counterRight-40)/5
            
        }
        
        intermediateFF = totalRotationsFastFF + totalRotationsSlowFF + totalRotationsMediumFF

    }
    
    func updateCounterLeft() {
        
        counterLeft++
        isRotatingRight = false
        var counterFloat = CGFloat(counterLeft) * 0.1
        buttonOnCollision = true
        
        if counterFloat <= 2{
            
            var spinLeft = SKAction.rotateByAngle(CGFloat(M_PI/10), duration: NSTimeInterval(0.1))
            player.runAction(spinLeft)
            
        } else if counterFloat > 2 && counterFloat <= 4 {
            
            var spinLeft = SKAction.rotateByAngle(CGFloat(M_PI/5.0), duration: NSTimeInterval(0.1))
            player.runAction(spinLeft)
            
        } else {
            
            var spinLeft = SKAction.rotateByAngle(CGFloat(M_PI/2.5), duration: NSTimeInterval(0.1))
            player.runAction(spinLeft)
            
        }
        
        if counterLeft <= 20 {
            
            totalRotationsSlowBF = (counterLeft/20)
            
        } else if counterLeft > 20 && counterLeft <= 40 {
            
            totalRotationsFastBF = (counterLeft-20)/10
            
        } else {
            
            totalRotationsFastBF = (counterLeft-40)/5
            
        }
        
        intermediateBF = totalRotationsFastBF + totalRotationsSlowBF + totalRotationsMediumBF
    }
    
    
    // MARK: Touches Began
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        intermediateBF = 0
        intermediateFF = 0
        totalRotationsSlowBF = 0
        totalRotationsFastBF = 0
        totalRotationsSlowFF = 0
        totalRotationsFastFF = 0

        for touch:AnyObject in touches {

            let location = touch.locationInNode(self)
            
            let node:SKSpriteNode? = self.nodeAtPoint(location) as? SKSpriteNode
            
                if !gamePaused{
                    
                    if node == rotateRight {
                            
                            timerLeft.invalidate()
                            
                            counterLeft = 0
                            
                            println("spinRight")
                            
                            //player.runAction(spinRightStart)
                            timerRight = NSTimer.scheduledTimerWithTimeInterval(0.1, target:self, selector: Selector("updateCounterRight"), userInfo: nil, repeats: true)
                        
                    } else if node == rotateLeft {
                    
                            timerRight.invalidate()
                            counterRight = 0
                            
                            println("spinLeft")
                        
                           // player.runAction(spinLeftStart)
                            timerLeft = NSTimer.scheduledTimerWithTimeInterval(0.1, target:self, selector: Selector("updateCounterLeft"), userInfo: nil, repeats: true)
                    
                    } else if tapToStartNode.containsPoint(location) {

                        if player.physicsBody!.dynamic {
                            return
                        }else{
                            tapToStartNode.removeFromParent()
                            player.physicsBody?.dynamic = true
                            player.physicsBody?.velocity = CGVector(dx: player.physicsBody!.velocity.dx, dy:config.startVelocity)
                            player.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: config.initialImpulse))
                            
                            hudNode.addChild(rotateLeft)
                            hudNode.addChild(rotateRight)
                            hudNode.addChild(btnPause)
                            rotateRight.position = CGPoint(x: xwidth - 50.0, y: 100)
                            rotateLeft.position = CGPoint(x: 50, y: 100)
                            btnPause.position = CGPoint(x: 50, y: lblFF.position.y - 80.0)


                        }
                        
                    }else if btnPause.containsPoint(location) {
                    
                            quitButt.position = CGPoint(x: xwidth/2, y: 240)
                            resumeButt.position = CGPoint(x:xwidth/2, y: (quitButt.size.height) + (quitButt.position.y + 40))
                            
                            pauseNode.addChild(quitButt)
                            pauseNode.addChild(resumeButt)
                            
                            hudNode.alpha = 0.3
                            foregroundNode.alpha = 0.3
                            midgroundNode.alpha = 0.3
                            
                            self.runAction(SKAction.runBlock(self.pauseTheGame))
                            
                    }
                    
                } else { //gamePause is true

                    gameIsPaused(location)
                }
        
        }

    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        for touch:AnyObject in touches {
            
            let location = touch.locationInNode(self)
        
            let touch = touches.first as! UITouch
        
            let node:SKSpriteNode? = self.nodeAtPoint(location) as? SKSpriteNode
        
            if node == rotateRight  {
                
                timerRight.invalidate()
                println("invalidate")
                
            
            } else if node == rotateLeft {
                
                timerLeft.invalidate()
                println("invalidate")
                
            }
        
            isRotatingRight == false
            isRotatingLeft == false
            buttonOnCollision = false
            allRotations = intermediateBF + intermediateFF + allRotations
        }
        
    }
    
    func gameIsPaused(location:CGPoint){
        
        if resumeButt.containsPoint(location){
            
            hudNode.alpha = 1.0
            foregroundNode.alpha = 1.0
            midgroundNode.alpha = 1.0
            
            quitButt.removeFromParent()
            resumeButt.removeFromParent()
            
            gamePaused = false
            self.view!.paused = false
            
            
        } else if quitButt.containsPoint(location){
            
            self.view!.paused = false
            
            let reveal = SKTransition.fadeWithDuration(0.5)
            let titleScene = TitleScene(size: self.size)
            self.view!.presentScene(titleScene, transition: reveal)
        }

        
    }
    
    func pauseTheGame() {

            gamePaused = true
            self.view!.paused = true

    }
    

    
    // MARK: Contact/Collision Stuff
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        var updateHUD = false
        var checkAngleBool = false
        let whichNode = (contact.bodyA.node != player) ? contact.bodyA.node : contact.bodyB.node
        let other = whichNode as! GameObjectNode

        updateHUD = other.collisionWithPlayer(player)
        checkAngleBool = other.collisionWithPlayer(player)
        
        
        if updateHUD {
            
            //collide with star
            
            
            if let star = other as? StarNode {
                
                starsConsumed += 1
                
                
                if star.starType == StarType.Special {
                    
                    endGame()

                } else if star.starType == StarType.Normal {
                    
                    starsTotal -= 1
                    
                }
                
                if starsTotal == 0 {
                    
                    endGame()
                    
                }
                
                
            }
            
            
            
        }
        
        if jumpCount == 0 {
            
            jumpCount += 1
            
        } else {
            if !checkAngleBool  {
                
                
                if buttonOnCollision{
                    
                    endGame()
                }
                
                let π = CGFloat(M_PI)
                radToDeg = (player.zRotation * 180.0)/π
                checkCollisionAngle()
            }
        }
    }
    
    func checkCollisionAngle() {
        
        if radToDeg >= 0 && radToDeg <= 20 || radToDeg <= 0 && radToDeg >= -20{
            
            perfectAngleAction()
            
        } else if radToDeg > 20 && radToDeg <= 45 || radToDeg < -20 && radToDeg >= -45 {
            
            goodAngleAction()
            
        } else if radToDeg > 45 && radToDeg < 155 || radToDeg < -45 && radToDeg > -155{
            
            badAngleAction()
            
        } else if radToDeg <= -155 && radToDeg >= -180 || radToDeg <= 180 && radToDeg >= 155{
            
            deadAngleAction()
        }

        
    }
    
    func perfectAngleAction() {
        
        perfectJumpCount += 1
        
        if jumpCount == 0 {
            
        } else {
            
            lblFlipType.alpha = 1.0
            let animateAction = SKAction.fadeAlphaTo(0.0, duration: 2)
            lblFlipType.runAction(animateAction)
        }
        
        if countRotSilent < allRotations{
        
            perfectJumpMultiplyer = perfectJumpMultiplyer + CGFloat((allRotations - countRotSilent)/5)
            newVelocity = config.currentVelocity + (perfectJumpMultiplyer * config.perfectJumpMultiplyerValue)
            
        } else {
            
            perfectJumpMultiplyer = 1
            newVelocity = config.currentVelocity
        }
        
        bounceAfterJumpAction()
            
    }

    func goodAngleAction() {
        
        
            perfectJumpMultiplyer = 0.0
            newVelocity = config.currentVelocity
            bounceAfterJumpAction()
        }

    func badAngleAction() {
        
            perfectJumpMultiplyer = 0.0
            newVelocity = config.badVelocity
            bounceAfterJumpAction()
        }

    func deadAngleAction() {
        
            endGame()
        
        }

    func bounceAfterJumpAction(){
        
        
        if starsTemp == starsTotal {
            jumpsInARow += 1
        }
        
        if jumpsInARow == 6 {
            
            endGame()
            
        }
        jumpCount = jumpCount + 1
        
        //Did user make any flips in current bounce
        countRotSilent = allRotations
        
        //If user had a bad jump and then makes a good/perfect jump boost him
        if config.currentVelocity <= config.badVelocity{
            
            config.currentVelocity = config.startVelocity
        }
        
        player.physicsBody?.velocity = CGVector(dx: player.physicsBody!.velocity.dx, dy: newVelocity)
        
        
        starsTemp = starsTotal
        config.currentVelocity = newVelocity
        totalRotationsSlowFF = 0
        totalRotationsFastFF = 0
        totalRotationsSlowBF = 0
        totalRotationsFastBF = 0
        intermediateFF = 0
        intermediateBF = 0
        
    }

    // MARK: Create Stuff
    
    func createPlayer() -> SKNode {
        var playerNode = SKNode()
        playerNode.position = CGPoint(x: self.size.width / 2, y: 220)
        
        var sprite = SKSpriteNode(imageNamed: "Player00")
        var pNumber: Int = 0
        
        let defaults = NSUserDefaults.standardUserDefaults()
        var pNJ = defaults.integerForKey("playerChoice")
        pNumber = pNJ
        sprite = SKSpriteNode(imageNamed:String(format: "Player%02d", pNumber))
        
        sprite.xScale = 1.0
        sprite.yScale = 1.0
        playerNode.addChild(sprite)
        playerNode.physicsBody = SKPhysicsBody(circleOfRadius: sprite.size.width / 2)
        playerNode.physicsBody?.dynamic = false
        playerNode.physicsBody?.allowsRotation = true
        playerNode.physicsBody?.restitution = 1.0
        playerNode.physicsBody?.friction = 0.0
        playerNode.physicsBody?.angularDamping = 1.0
        playerNode.physicsBody?.linearDamping = 0.0
        
        playerNode.physicsBody?.usesPreciseCollisionDetection = true
        playerNode.physicsBody?.categoryBitMask = CollisionCategoryBitmask.Player
        playerNode.physicsBody?.collisionBitMask = 0
        playerNode.physicsBody?.contactTestBitMask = CollisionCategoryBitmask.Star | CollisionCategoryBitmask.Platform
        
        return playerNode
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
        
        let node = SKSpriteNode(imageNamed: String(format: "Background"))
        node.setScale(scaleFactor)
        node.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        node.position = CGPoint(x: self.size.width / 2, y: 0)
        backgroundNode.addChild(node)
        
        return backgroundNode
    }

    func createPlatformAtPosition(position: CGPoint, ofType type: PlatformType) -> PlatformNode {

        let node = PlatformNode()
        let thePosition = CGPoint(x: position.x, y: position.y)
        node.position = thePosition
        node.name = "NODE_PLATFORM"
        node.platformType = type
        
        var sprite: SKSpriteNode!
        
   
        sprite = SKSpriteNode(imageNamed: "Platform")
        sprite.size = CGSize(width: sprite.size.width * scaleFactor, height: sprite.size.height * scaleFactor)
        
        node.addChild(sprite)
        node.physicsBody = SKPhysicsBody(rectangleOfSize: sprite.size)
        node.physicsBody?.dynamic = false
        node.physicsBody?.categoryBitMask = CollisionCategoryBitmask.Platform
        node.physicsBody?.collisionBitMask = 0
        
        return node
    }
    
    func createStarAtPosition(position: CGPoint, ofType type: StarType) -> StarNode {
        
        let node = StarNode()
        let thePosition = CGPoint(x: position.x * scaleFactor, y: position.y)
        node.position = thePosition
        node.name = "NODE_STAR"
        node.starType = type
        var sprite: SKSpriteNode!
        
        if type == .Special {
            
            sprite = SKSpriteNode(imageNamed: "starRed")
            
        } else {
            
            sprite = SKSpriteNode(imageNamed: "starYellow")
            starsTotal += 1
            
        }
        
        node.addChild(sprite)
        node.physicsBody = SKPhysicsBody(circleOfRadius: sprite.size.width / 2)
        node.physicsBody?.dynamic = false
        node.physicsBody?.categoryBitMask = CollisionCategoryBitmask.Star
        node.physicsBody?.collisionBitMask = 0
        node.physicsBody?.contactTestBitMask = 0
        return node
    }


    /*
    func createMidgroundNode() -> SKNode {

        let theMidgroundNode = SKNode()
        var anchor: CGPoint!
        var xPosition: CGFloat!
        
        for index in 0...9 {
            var spriteName: String
           
            let r = arc4random() % 2
            if r > 0 {
                
                spriteName = "BranchRight"
                anchor = CGPoint(x: 1.0, y: 0.5)
                xPosition = self.size.width
                
            } else {
                
                spriteName = "BranchLeft"
                anchor = CGPoint(x: 0.0, y: 0.5)
                xPosition = 0.0
                
            }
       
            let branchNode = SKSpriteNode(imageNamed: spriteName)
            branchNode.anchorPoint = anchor
            branchNode.position = CGPoint(x: xPosition, y: 500.0 * CGFloat(index))
            theMidgroundNode.addChild(branchNode)
        }
        
        return theMidgroundNode
    }
 */
    
    // MARK: Update
    
    override func update(currentTime: NSTimeInterval) {
        
        //println("Psoition: \(player.position.y)")
        //println("Psoition: \(player.position.x)")
        
        if gameOver {
            return
        }
        
        if Int(player.position.y) > maxPlayerY {
            
            maxPlayerY = Int(player.position.y)
            
            if maxPlayerY > GameState.sharedInstance.recordHeight {
                
                GameState.sharedInstance.recordHeight = maxPlayerY
                
            }
            
            lblHeight.text = String(maxPlayerY - 220)

        }
        
        // Calculate Score
        GameState.sharedInstance.score = (maxPlayerY - 220) + (starsConsumed * 25) + (allRotations * 10) + (perfectJumpCount * 100)
        
        lblScore.text = String(format: "%d", GameState.sharedInstance.score)
        //heightMarkery = CGFloat(GameState.sharedInstance.recordHeight)
        
        foregroundNode.enumerateChildNodesWithName("NODE_PLATFORM", usingBlock: {
        (node, stop) in
            
        let platform = node as! PlatformNode

        })
        
        foregroundNode.enumerateChildNodesWithName("NODE_STAR", usingBlock: {
            (node, stop) in
            let star = node as! StarNode
            
        })
        
        if player.position.y > 200.0 {
            backgroundNode.position = CGPoint(x: 0.0, y: -((player.position.y - 200.0)/10))
           // midgroundNode.position = CGPoint(x: 0.0, y: -((player.position.y - 200.0)/4))
            foregroundNode.position = CGPoint(x: 0.0, y: -(player.position.y - 200.0))
        }
        
        if Int(player.position.y) > endLevelY {
            winGame()
        }
        
        if Int(player.position.y) < 20 {
            endGame()
        }
        
        
        lblFF.text = String(format: "%d", intermediateFF)
        lblBF.text = String(format: "%d", intermediateBF)
        lblAllFlips.text = String(format: "%d", allRotations)

    }
    
    override func didSimulatePhysics() {

        player.physicsBody?.velocity = CGVector(dx: xAcceleration * config.startVelocity, dy: player.physicsBody!.velocity.dy)

        if player.position.x < -20.0 {
            
            player.position = CGPoint(x: xwidth, y: player.position.y)
            
        } else if (player.position.x > xwidth) {
            
            player.position = CGPoint(x: -20.0, y: player.position.y)
            
        }
        
    }
    
    func endGame() {
        
        if GameState.sharedInstance.score > GameState.sharedInstance.highScore{
            
            GCHelper.sharedInstance.reportLeaderboardIdentifier(config.LeaderboardID, score: GameState.sharedInstance.score)
            
        }
        
        timerRight.invalidate()
        timerLeft.invalidate()
        gameOver = true
        GameState.sharedInstance.saveState()
        rotateLeft.removeFromParent()
        rotateRight.removeFromParent()
        btnPause.removeFromParent()
        let reveal = SKTransition.fadeWithDuration(0.5)
        let endGameScene = EndGameScene(size: self.size, didWin: false, allStars: false)
        
        let scaleAction:SKAction = SKAction.scaleTo(0.2, duration: 3)
        let fadeAction:SKAction = SKAction.fadeAlphaTo(0, duration:3)
        let rotateAction = SKAction.rotateByAngle(CGFloat(M_PI * 12), duration: 3)
        let group:SKAction = SKAction.group([scaleAction, fadeAction, rotateAction])
        
        let transition = SKTransition.doorsCloseHorizontalWithDuration(1.5)
        self.view!.presentScene(endGameScene, transition: transition)

    }
    
    func winGame() {
        
        if GameState.sharedInstance.score > GameState.sharedInstance.highScore{
            
            GCHelper.sharedInstance.reportLeaderboardIdentifier(config.LeaderboardID, score: GameState.sharedInstance.score)
            
        }
        
        timerRight.invalidate()
        timerLeft.invalidate()
        gameOver = true
        GameState.sharedInstance.saveState()
        rotateLeft.removeFromParent()
        rotateRight.removeFromParent()
        btnPause.removeFromParent()
        let reveal = SKTransition.fadeWithDuration(0.5)
        var endGameScene = EndGameScene(size: self.size, didWin: false, allStars: false)
        
        if starsTotal == 0 {
            
            endGameScene = EndGameScene(size: self.size, didWin: true, allStars: true)
            
        } else {
       
            endGameScene = EndGameScene(size: self.size, didWin: true, allStars: false)
   
        }
        
        let scaleAction:SKAction = SKAction.scaleTo(0.2, duration: 3)
        let fadeAction:SKAction = SKAction.fadeAlphaTo(0, duration:3)
        let rotateAction = SKAction.rotateByAngle(CGFloat(M_PI * 12), duration: 3)
        let group:SKAction = SKAction.group([scaleAction, fadeAction, rotateAction])
        
        let transition = SKTransition.fadeWithColor(UIColor.yellowColor(), duration: 1.5)
        self.view!.presentScene(endGameScene, transition: transition)

        
    }
}
