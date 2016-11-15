//
//  GameScene.swift
//  xwing-fight
//
//  Created by puc-dev on 10/23/16.
//  Copyright © 2016 puc-dev. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    
    var spacebg :SKSpriteNode? ;

    var aircraft :SKSpriteNode? ;
    var shots = [SKSpriteNode]();
    var fire = false;
    
    var lastAsteroidCreated = 

    var asteroid1, asteroid2, asteroid3 : SKSpriteNode?;
    
    var points = 0;
    var pointsLabel = SKLabelNode();
    
    override func didMove(to view: SKView) {
        print("Starting Game Scene...")
        
        aircraft = SKSpriteNode(texture: SKTexture(imageNamed: "aircraft.png"))
        spacebg = SKSpriteNode(texture: SKTexture(imageNamed: "space-bg.jpg"))
        asteroid1 = SKSpriteNode(texture: SKTexture(imageNamed: "asteroids/asteroid-1.png"))
        asteroid2 = SKSpriteNode(texture: SKTexture(imageNamed: "asteroids/asteroid-2.png"))
        asteroid3 = SKSpriteNode(texture: SKTexture(imageNamed: "asteroids/asteroid-3.png"))
        
        spacebg?.zPosition = -1;
        spacebg?.yScale = 2;
        spacebg?.xScale = 2;
        spacebg?.position = CGPoint(x:0,y:self.size.height)
        
        pointsLabel.position = CGPoint(x:0,y:self.size.height)
        pointsLabel.text = "Points: 0";
        
        aircraft?.scale(to: CGSize(width: 64, height: 110))
        aircraft?.position = CGPoint(x:0, y: 0)
        
        addChild(aircraft!)
        addChild(spacebg!)
        
        let fireAction = SKAction.run({
            if(self.fire) {
                let fire = SKSpriteNode(color: SKColor.white, size: CGSize(width: 5, height: 8));
                let action = SKAction.sequence([SKAction.move(to: CGPoint(x:(self.aircraft?.position.x)!,y: self.size.height+(self.aircraft?.position.y)!), duration: TimeInterval(1)), SKAction.run({
                    fire.removeFromParent()
                })])
                fire.position = CGPoint(x:(self.aircraft?.position.x)!, y:(self.aircraft?.position.y)!+45)
                self.addChild(fire)
                fire.run(action)
            }
        });
        
        
        
        aircraft?.run(SKAction.repeatForever(SKAction.sequence([SKAction.wait(forDuration: TimeInterval(0.1)), fireAction])))
        
        let asteroidAction = SKAction.run ({
            
        })
        
        aircraft?.run(SKAction.repeatForever(SKAction.sequence([SKAction.wait(forDuration: TimeInterval(0.1)), asteroidAction])))
        
    }
    
    func touchDown(atPoint pos : CGPoint) {
        let move = SKAction.move(to: pos, duration: 0);
        aircraft?.run(move);
        self.fire = true
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        let move = SKAction.move(to: pos, duration: 0);
        aircraft?.run(move);
    }
    
    func touchUp(atPoint pos : CGPoint) {
        self.fire = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
