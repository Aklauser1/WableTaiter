//
//  GameScene.swift
//  Wable Taiter
//
//  Created by Brandon Schmidt on 12/11/18.
//  Copyright © 2018 Drew Klauser. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // created all of my variables
    var gameStarted = Bool(false)
    var died = Bool(false)
    let tipSound = SKAction.playSoundFileNamed("Cash.wav", waitForCompletion: false)
    let deadSound = SKAction.playSoundFileNamed("death.mp3", waitForCompletion: false)
    var score = Int(0)
    var scoreLbl = SKLabelNode()
    var highscoreLbl = SKLabelNode()
    var taptoplayLbl = SKLabelNode()
    var directions = SKLabelNode()
    var restartBtn = SKSpriteNode()
    var pauseBtn = SKSpriteNode()
    var logoImg = SKSpriteNode()
    var tablePair = SKNode()
    var moveAndRemove = SKAction()
    
    //creates the player/waiter atlas
    let waiterAtlas = SKTextureAtlas(named:"player")
    var waiter = SKSpriteNode(imageNamed: "waiter")
    
    override func didMove(to view: SKView) {
        createScene()
    }
    
    
    //when the user touches the screen initially
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameStarted == false{
            
            //starts the game
            gameStarted =  true
            waiter.physicsBody?.affectedByGravity = false
            
            //creates the pause button
            createPauseBtn()
            
            //removes the logo
            logoImg.run(SKAction.scale(to: 0.5, duration: 0.3), completion: {
                self.logoImg.removeFromParent()
            })
            
            //removes aspects of the start screen
            taptoplayLbl.removeFromParent()
            directions.removeFromParent()
            
            //starts the spawn of the tables
            let spawn = SKAction.run({
                () in
                self.tablePair = self.createTables()
                self.addChild(self.tablePair)
            })
            
            //delays the tables to give the user room to move in between
            let delay = SKAction.wait(forDuration: 2.4)
            let SpawnDelay = SKAction.sequence([spawn, delay])
            let spawnDelayForever = SKAction.repeatForever(SpawnDelay)
            self.run(spawnDelayForever)
            
            //moves the tables down the screen in a certain amount of time
            let distance = CGFloat(self.frame.height + tablePair.frame.height)
            let moveTables = SKAction.moveBy(x: 0, y: -distance - 50, duration: TimeInterval(0.006 * distance))
            let removeTables = SKAction.removeFromParent()
            moveAndRemove = SKAction.sequence([moveTables, removeTables])
            
            
        }
        for touch in touches{
            let location = touch.location(in: self)
            if died == true{
                
                //sets the high score label if a new high score is achieved
                if restartBtn.contains(location){
                    if UserDefaults.standard.object(forKey: "highestScore") != nil {
                        let hscore = UserDefaults.standard.integer(forKey: "highestScore")
                        if hscore < score {
                            UserDefaults.standard.set(score, forKey: "highestScore")
                        }
                    } else {
                        UserDefaults.standard.set(0, forKey: "highestScore")
                    }
                    restartScene()
                }
            } else {
                if pauseBtn.contains(location){
                    if self.isPaused == false{
                        self.isPaused = true
                        pauseBtn.texture = SKTexture(imageNamed: "play")
                    } else {
                        self.isPaused = false
                        pauseBtn.texture = SKTexture(imageNamed: "pause")
                    }
                }
            }
        }
    }
    
    //function to restart the screen when dead
    func restartScene(){
        self.removeAllChildren()
        self.removeAllActions()
        died = false
        gameStarted = false
        score = 0
        createScene()
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch : UITouch! = touches.first! as UITouch
        if gameStarted == false{
            waiter.position = CGPoint(x:self.frame.midX, y:self.frame.midY - self.frame.midY / 2)
        }
        else {
            waiter.position = touch.location(in:self)
        }
    }
    func createScene(){
        //using the physsics body
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody?.categoryBitMask = CollisionBitMask.groundCategory
        self.physicsBody?.collisionBitMask = CollisionBitMask.waiterCategory
        self.physicsBody?.contactTestBitMask = CollisionBitMask.waiterCategory
        self.physicsBody?.isDynamic = false
        self.physicsBody?.affectedByGravity = false
        
        self.physicsWorld.contactDelegate = self
        
        //setting background color to black
        self.backgroundColor = SKColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0)
        
        //looping the background creation process infinite times
        for i in 0..<2 {
            let background = SKSpriteNode(imageNamed: "bg")
            background.anchorPoint = CGPoint.init(x: 0, y: 0)
            background.position = CGPoint(x:0, y:CGFloat(i) * self.frame.height)
            background.name = "background"
            background.size = (self.view?.bounds.size)!
            self.addChild(background)
        }
        
        self.waiter = createWaiter()
        self.addChild(waiter)
    
        scoreLbl = createScoreLabel()
        self.addChild(scoreLbl)
        
        highscoreLbl = createHighscoreLabel()
        self.addChild(highscoreLbl)
        
        createLogo()
        directions = createDirections()
        self.addChild(directions)
        
        taptoplayLbl = createTaptoplayLabel()
        self.addChild(taptoplayLbl)
    }
    
    //creates what happens when contact is involved
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        
        //between waiter and tables or ground
        if firstBody.categoryBitMask == CollisionBitMask.waiterCategory && secondBody.categoryBitMask == CollisionBitMask.tableCategory || firstBody.categoryBitMask == CollisionBitMask.tableCategory && secondBody.categoryBitMask == CollisionBitMask.waiterCategory || firstBody.categoryBitMask == CollisionBitMask.waiterCategory && secondBody.categoryBitMask == CollisionBitMask.groundCategory || firstBody.categoryBitMask == CollisionBitMask.groundCategory && secondBody.categoryBitMask == CollisionBitMask.waiterCategory{
            enumerateChildNodes(withName: "tablePair", using: ({
                (node, error) in
                node.speed = 0
                self.removeAllActions()
            }))
            if died == false{
                died = true
                run(deadSound)
                createRestartBtn()
                pauseBtn.removeFromParent()
                self.waiter.removeAllActions()
            }
            
            //between waiter and tips
        } else if firstBody.categoryBitMask == CollisionBitMask.waiterCategory && secondBody.categoryBitMask == CollisionBitMask.tipsCategory {
            run(tipSound)
            score += 1
            scoreLbl.text = "$\(score)"
            secondBody.node?.removeFromParent()
        } else if firstBody.categoryBitMask == CollisionBitMask.tipsCategory && secondBody.categoryBitMask == CollisionBitMask.waiterCategory {
            run(tipSound)
            score += 1
            scoreLbl.text = "$\(score)"
            firstBody.node?.removeFromParent()
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        // Called before each frame is rendered
        if gameStarted == true{
            if died == false{
                enumerateChildNodes(withName: "background", using: ({
                    (node, error) in
                    
                    //moves the background at a certain speed
                    let bg = node as! SKSpriteNode
                    bg.position = CGPoint(x: bg.position.x, y: bg.position.y - 11)
                    if bg.position.y <= -bg.size.height {
                        bg.position = CGPoint(x:bg.position.x, y:bg.position.y + bg.size.height * 2)
                    }
                }))
            }
        }
    }
}











