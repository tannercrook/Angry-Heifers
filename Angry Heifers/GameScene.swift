//
//  GameScene.swift
//  Angry Heifers
//
//  Created by Tanner Crook on 6/6/15.
//  Copyright (c) 2015 Tanner Crook. All rights reserved.
//


import SpriteKit
import UIKit


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var cow : SKSpriteNode!
    var cowboy : SKSpriteNode!
    var lazyCowFrames : [SKTexture]!
    var runCowboyFrames : [SKTexture]!
    var playButton: SKSpriteNode!
    var ground: SKSpriteNode!
    var groundTwo: SKSpriteNode!
    var groundThree: SKSpriteNode!
    var moveSpeed = 10.0
    
    var cowboyOnGround: Bool = true
    
    let cowboyCategory: UInt32 = 0x1 << 0;
    let groundCategory: UInt32 = 0x1 << 1;
    
    
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        // handle collsions
        self.physicsWorld.contactDelegate = self
        
        self.physicsWorld.gravity = CGVectorMake(0.0, -2.0)
        
        
        let cowAnimatedAtlas = SKTextureAtlas(named: "RunCowImages")
        var lazyFrames = [SKTexture]()
        
        let numImages = cowAnimatedAtlas.textureNames.count
        for (var i=1; i<=numImages; i++) {
            let cowTextureName = "runcow\(i)"
            lazyFrames.append(cowAnimatedAtlas.textureNamed(cowTextureName))
        }
        
        lazyCowFrames = lazyFrames
        
        let firstFrame = lazyCowFrames[0]
        
        
        
        // Cowboy Animation
        
        
        
        let cowboyAnimatedAtlas = SKTextureAtlas(named: "CowboyRuns")
        var cowboyFrames = [SKTexture]()
        
        let cowboyNumImages = cowboyAnimatedAtlas.textureNames.count
        for (var i=1; i<=cowboyNumImages; i++) {
            let cowboyTextureName = "cowboyRun\(i)"
            cowboyFrames.append(cowboyAnimatedAtlas.textureNamed(cowboyTextureName))
        }
        
        runCowboyFrames = cowboyFrames
        
        let cowboyFirstFrame = runCowboyFrames[0]
        
        
        cow = SKSpriteNode(texture: firstFrame)
        cow.position = CGPointMake(0.0, 190.0)
        cow.size = CGSizeMake(123, 102.0)
        
        
        // Lets create our basic nodes
        let sky = SKSpriteNode(imageNamed: "sky")
        ground = SKSpriteNode(imageNamed: "ground")
        groundTwo = SKSpriteNode(imageNamed: "ground")
        groundThree = SKSpriteNode(imageNamed: "ground")
        cowboy = SKSpriteNode(texture: cowboyFirstFrame)
        playButton = SKSpriteNode(imageNamed: "playbutton")
        
        
        
        
        // TITLE LABEL
        let titleLabel = SKLabelNode(fontNamed: "Chalkduster")
        titleLabel.fontSize = 48
        titleLabel.fontColor = UIColor.blackColor()
        titleLabel.text = "Angry Hiefers"
        titleLabel.position = CGPointMake(200, 600)
        
        sky.position = CGPointMake(208.077, 367.156)
        sky.size = CGSizeMake(415.45, 738.461)
        
        ground.size = CGSizeMake(450.0, 100.0)
        ground.position = CGPointMake(225.0, 50.0)
        groundTwo.size = CGSizeMake(450.0, 100.0)
        groundTwo.position = CGPointMake(675.0, 50.0)
        groundThree.size = CGSizeMake(450.0, 100.0)
        groundThree.position = CGPointMake(1125.0, 50.0)
        
        cowboy.size = CGSizeMake(71, 80)
        cowboy.position = CGPointMake(250.0, 190.0)
        
        playButton.size = CGSizeMake(290, 190)
        playButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        
        
        // playButton.userInteractionEnabled = true;
        playButton.name = "playButton"
        
        cow.physicsBody = SKPhysicsBody(circleOfRadius: cow.size.height / 2.75)
        cow.physicsBody!.dynamic = true
        
        let square = CGSize(width: ground.size.width, height: ground.size.height)
        ground.physicsBody = SKPhysicsBody(rectangleOfSize: square)
        ground.physicsBody!.dynamic = false
        ground.physicsBody?.categoryBitMask = groundCategory
        groundTwo.physicsBody = SKPhysicsBody(rectangleOfSize: square)
        groundTwo.physicsBody!.dynamic = false
        groundTwo.physicsBody?.categoryBitMask = groundCategory
        groundThree.physicsBody = SKPhysicsBody(rectangleOfSize: square)
        groundThree.physicsBody!.dynamic = false
        groundThree.physicsBody?.categoryBitMask = groundCategory
        
        cowboy.physicsBody = SKPhysicsBody(circleOfRadius: cowboy.size.height / 2.75)
        cowboy.physicsBody!.dynamic = true
        cowboy.physicsBody?.categoryBitMask = cowboyCategory
        cowboy.physicsBody?.contactTestBitMask = groundCategory
        cowboy.physicsBody?.collisionBitMask = 10;
        cowboy.physicsBody?.usesPreciseCollisionDetection
        
        
        
        
        // Lets build the view now.
        
        
        addChild(sky)
        addChild(ground)
        addChild(groundTwo)
        addChild(groundThree)
        addChild(cowboy)
        addChild(titleLabel)
        addChild(playButton)
        
    }
    
    func lazyCow() {
        //This is our general runAction method to make our cow move.
        cow.runAction(SKAction.repeatActionForever(
            SKAction.animateWithTextures(lazyCowFrames,
                timePerFrame: 0.3,
                resize: false,
                restore: true)),
            withKey:"lazyCow")
    }
    
    func runCowboy() {
        //This is our general runAction method to make our cow move.
        cowboy.runAction(SKAction.repeatActionForever(
            SKAction.animateWithTextures(runCowboyFrames,
                timePerFrame: 0.2,
                resize: false,
                restore: true)),
            withKey:"runCowboy")
    }
    
    func moveGround() {
        
        
        var startOne = SKAction.moveTo(CGPointMake(-225.0, 50.0), duration: moveSpeed / 3.0)
        var startTwo = SKAction.moveTo(CGPointMake(-225.0, 50.0), duration: moveSpeed / 1.5)
        var moveGroundAction = SKAction.moveTo(CGPointMake(-225.0, 50.0), duration: moveSpeed)
        var resetGroundAction = SKAction.moveTo(CGPointMake(1125.0, 50.0), duration: 0.0)
        var hideGround = SKAction.hide()
        var unhideGround = SKAction.unhide()
        ground.runAction(SKAction.sequence([startOne, SKAction.repeatActionForever(SKAction.sequence([hideGround, resetGroundAction, unhideGround, moveGroundAction]))]), withKey: "moveGround")
        groundTwo.runAction(SKAction.sequence([startTwo, SKAction.repeatActionForever(SKAction.sequence([hideGround, resetGroundAction, unhideGround, moveGroundAction]))]), withKey: "moveGroundTwo")
        groundThree.runAction(SKAction.repeatActionForever(SKAction.sequence([unhideGround, moveGroundAction, hideGround, resetGroundAction])), withKey:"moveGroundTwo")
        
    }
    
    func changeGroundSpeed(speed: Double) {
        moveSpeed = speed
        var startOne = SKAction.moveTo(CGPointMake(-225.0, 50.0), duration: moveSpeed / 3.0)
    }
    
    func playNow() {
        var midx = CGRectGetMidX(self.frame)
        var midy = CGRectGetMidY(self.frame)
        var midPlus = CGPointMake(midx, midy - 20)
        var moveButtonPress = SKAction.moveTo(midPlus, duration: 0.5)
        var moveButtonOff = SKAction.moveTo(CGPointMake(200, 900), duration: 1.0)
        // var walkIn = SKAction.moveTo(CGPointMake(220.0, 100.0), duration: 2.0)
        var walkIn = SKAction.moveToX(100.0, duration: 1.0)
        var wait = SKAction.waitForDuration(moveButtonPress.duration)
        
        
        playButton.runAction(SKAction.sequence([moveButtonPress,moveButtonOff]))
        
        cow.runAction(walkIn)
        moveGround()
        addChild(cow)
        lazyCow()
        runCowboy()
        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            let node = self.nodeAtPoint(location) //1
            if node.name == "playButton" { //2
                playNow()
            }
            jump()
        }
    }
    
    func jump() {
        if cowboyOnGround {
            var impulseX: CGFloat = 0.0
            var impulseY: CGFloat  = 25.0
            cowboy.physicsBody?.applyImpulse(CGVectorMake(impulseX, impulseY), atPoint: cowboy.position)
            moveSpeed = moveSpeed - 1
            cowboyOnGround = false
        }
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        var collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        println("collision")
        
        if (collision == (cowboyCategory | groundCategory)) {
            
            cowboyOnGround = true
            
        }
        else if (collision == (groundCategory | cowboyCategory)) {
            cowboyOnGround = true
        }
        
    }
    
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
}
