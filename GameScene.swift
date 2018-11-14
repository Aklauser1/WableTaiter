//
//  GameScene.swift
//  Wable Taiter
//
//  Created by Brandon Schmidt on 11/14/18.
//  Copyright © 2018 Drew Klauser. All rights reserved.
//

import SpriteKit
class GameScene: SKScene {
    
    var ground = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        createGrounds()
    }
    override func update(_ currentTime: CFTimeInterval) {
        moveGrounds()
    }
    func createGrounds(){
        for i in 0...3 {
            let ground = SKSpriteNode(imageNamed: "image")
            ground.name = "Ground"
            ground.size = CGSize(width: (self.scene?.size.width)!, height: ((self.scene?.size.height)!))
            ground.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            ground.position = CGPoint(x: 0, y: CGFloat(i) * ground.size.height)
            self.addChild(ground)
        }
    }
    func moveGrounds() {
        self.enumerateChildNodes(withName: "Ground", using: ({
            (node, error) in
            node.position.y -= 2
            
            if node.position.x < -((self.scene?.size.width)!){
                node.position.x += (self.scene?.size.width)! * 3
            }
        }))
    }
}
