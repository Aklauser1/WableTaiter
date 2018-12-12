//
//  Simthing.swift
//  Wable Taiter
//
//  Created by Brandon Schmidt on 12/11/18.
//  Copyright © 2018 Drew Klauser. All rights reserved.
//

import SpriteKit

//added the collisionbitmasks for each of the elements
struct CollisionBitMask {
    static let waiterCategory:UInt32 = 0x1 << 0
    static let tableCategory:UInt32 = 0x1 << 1
    static let tipsCategory:UInt32 = 0x1 << 2
    static let groundCategory:UInt32 = 0x1 << 3
}

extension GameScene{
    
    //create a function that will create the waiter with the given specs
    func createWaiter() -> SKSpriteNode {
        let waiter = SKSpriteNode(imageNamed: "waiter")
        waiter.size = CGSize(width: 150, height: 200)
        waiter.position = CGPoint(x:self.frame.midX, y:self.frame.midY - self.frame.midY / 2)
        
        waiter.physicsBody = SKPhysicsBody(circleOfRadius: waiter.size.width / 2)
        waiter.physicsBody?.linearDamping = 1.1
        waiter.physicsBody?.restitution = 0
        waiter.physicsBody?.categoryBitMask = CollisionBitMask.waiterCategory
        waiter.physicsBody?.collisionBitMask = CollisionBitMask.tableCategory | CollisionBitMask.groundCategory
        waiter.physicsBody?.contactTestBitMask = CollisionBitMask.tableCategory | CollisionBitMask.tipsCategory | CollisionBitMask.groundCategory
        waiter.physicsBody?.affectedByGravity = false
        waiter.physicsBody?.isDynamic = true
        
        return waiter
    }
    
    // will create the restart button in the middle of the screen
    func createRestartBtn() {
        restartBtn = SKSpriteNode(imageNamed: "restart")
        restartBtn.size = CGSize(width:100, height:100)
        restartBtn.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        restartBtn.zPosition = 6
        restartBtn.setScale(0)
        self.addChild(restartBtn)
        restartBtn.run(SKAction.scale(to: 1.0, duration: 0.3))
    }
    
    // will create the pause button in bottom right corner
    func createPauseBtn() {
        pauseBtn = SKSpriteNode(imageNamed: "pause")
        pauseBtn.size = CGSize(width:40, height:40)
        pauseBtn.position = CGPoint(x: self.frame.width - 30, y: 30)
        pauseBtn.zPosition = 6
        self.addChild(pauseBtn)
    }
    
    //creates the score label and background
    func createScoreLabel() -> SKLabelNode {
        let scoreLbl = SKLabelNode()
        scoreLbl.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 + self.frame.height / 2.6)
        scoreLbl.text = "$\(score)"
        scoreLbl.zPosition = 5
        scoreLbl.fontSize = 50
        scoreLbl.fontName = "HelveticaNeue-Bold"
        
        let scoreBg = SKShapeNode()
        scoreBg.position = CGPoint(x: 0, y: 0)
        scoreBg.path = CGPath(roundedRect: CGRect(x: CGFloat(-50), y: CGFloat(-30), width: CGFloat(100), height: CGFloat(100)), cornerWidth: 50, cornerHeight: 50, transform: nil)
        let scoreBgColor = UIColor(red: CGFloat(0.0 / 255.0), green: CGFloat(0.0 / 255.0), blue: CGFloat(0.0 / 255.0), alpha: CGFloat(0.2))
        scoreBg.strokeColor = UIColor.clear
        scoreBg.fillColor = scoreBgColor
        scoreBg.zPosition = -1
        scoreLbl.addChild(scoreBg)
        return scoreLbl
    }
    
    //creates the highscore label in tht top right corner
    func createHighscoreLabel() -> SKLabelNode {
        let highscoreLbl = SKLabelNode()
        highscoreLbl.position = CGPoint(x: self.frame.width - 80, y: self.frame.height - 22)
        if let highestScore = UserDefaults.standard.object(forKey: "highestScore"){
            highscoreLbl.text = "Most Tips : $\(highestScore)"
        } else {
            highscoreLbl.text = "Most Tips : $0"
        }
        highscoreLbl.zPosition = 5
        highscoreLbl.fontSize = 15
        highscoreLbl.color = UIColor.black
        highscoreLbl.fontName = "Helvetica-Bold"
        return highscoreLbl
    }
    
    //creates the logo in the top center of the screen
    func createLogo() {
        logoImg = SKSpriteNode()
        logoImg = SKSpriteNode(imageNamed: "logo")
        logoImg.size = CGSize(width: 500, height: 400)
        logoImg.position = CGPoint(x:self.frame.midX + 5, y:self.frame.midY + 150)
        logoImg.setScale(0.5)
        self.addChild(logoImg)
        logoImg.run(SKAction.scale(to: 1.0, duration: 0.3))
        
    }
    
    //adds in the directions for the app
    func createDirections() -> SKLabelNode {
        let directions = SKLabelNode()
        directions.position = CGPoint(x:self.frame.midX, y:self.frame.midY + 15)
        directions.text = "Avoid the customers and collect the tips"
        directions.fontColor = UIColor(red: 63/255, green: 79/255, blue: 145/255, alpha: 1.0)
        directions.fontSize = 21
        directions.zPosition = 5
        directions.fontName = "HelveticaNeueBold"
        return directions 
    }
    
    //creates the label telling user how to start game
    func createTaptoplayLabel() -> SKLabelNode {
        let taptoplayLbl = SKLabelNode()
        taptoplayLbl.position = CGPoint(x:self.frame.midX, y:self.frame.midY - 50)
        taptoplayLbl.text = "Tap on the waiter to play"
        taptoplayLbl.fontColor = UIColor(red: 63/255, green: 79/255, blue: 145/255, alpha: 1.0)
        taptoplayLbl.zPosition = 5
        taptoplayLbl.fontSize = 25
        taptoplayLbl.fontName = "HelveticaNeueBold"
        return taptoplayLbl
    }
    
    //works on creating the tables to be spawned in with the tips located in the middle of the table
    func createTables() -> SKNode  {
        let tipsNode = SKSpriteNode(imageNamed: "tips")
        tipsNode.size = CGSize(width: 60, height: 60)
        tipsNode.position = CGPoint(x: self.frame.width / 2, y: self.frame.height + 5)
        tipsNode.physicsBody = SKPhysicsBody(rectangleOf: tipsNode.size)
        tipsNode.physicsBody?.affectedByGravity = false
        tipsNode.physicsBody?.isDynamic = false
        tipsNode.physicsBody?.categoryBitMask = CollisionBitMask.tipsCategory
        tipsNode.physicsBody?.collisionBitMask = 0
        tipsNode.physicsBody?.contactTestBitMask = CollisionBitMask.waiterCategory
        tipsNode.color = SKColor.blue
        
        tablePair = SKNode()
        tablePair.name = "tablePair"
        
        let topTable = SKSpriteNode(imageNamed: "table")
        let btmTable = SKSpriteNode(imageNamed: "table")
        
        topTable.position = CGPoint(x: self.frame.width + 25, y: self.frame.height / 2 + 420)
        btmTable.position = CGPoint(x: -25, y: self.frame.height / 2 + 420)
        
        //sets the size of the tables to scale
        topTable.setScale(0.3)
        btmTable.setScale(0.3)
        
        //sets the physics for the top table
        topTable.physicsBody = SKPhysicsBody(rectangleOf: topTable.size)
        topTable.physicsBody?.categoryBitMask = CollisionBitMask.tableCategory
        topTable.physicsBody?.collisionBitMask = CollisionBitMask.waiterCategory
        topTable.physicsBody?.contactTestBitMask = CollisionBitMask.waiterCategory
        topTable.physicsBody?.isDynamic = false
        topTable.physicsBody?.affectedByGravity = false
        
        //sets the physics for the bottom table
        btmTable.physicsBody = SKPhysicsBody(rectangleOf: btmTable.size)
        btmTable.physicsBody?.categoryBitMask = CollisionBitMask.tableCategory
        btmTable.physicsBody?.collisionBitMask = CollisionBitMask.waiterCategory
        btmTable.physicsBody?.contactTestBitMask = CollisionBitMask.waiterCategory
        btmTable.physicsBody?.isDynamic = false
        btmTable.physicsBody?.affectedByGravity = false
        
        //adds both of the tables to the view
        tablePair.addChild(topTable)
        tablePair.addChild(btmTable)
        
        tablePair.zPosition = 1
        
        //creates a random position that will allow the table and tips to be on the screen
        let randomPosition = random(min: -180, max: 180)
        tablePair.position.x = tablePair.position.x +  randomPosition
        tablePair.addChild(tipsNode)
        
        tablePair.run(moveAndRemove)
        
        return tablePair
    }
    
    func random() -> CGFloat{
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min : CGFloat, max : CGFloat) -> CGFloat{
        return random() * (max - min) + min
    }
    
}
