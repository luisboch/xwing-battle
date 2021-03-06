//
//  GameScene.swift
//  xwing-fight
//
//  Created by puc-dev on 10/23/16.
//  Copyright © 2016 puc-dev. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

class GameScene: SKScene {
    
    
    var spacebg :SKSpriteNode? ;
    
    var aircraft :SKSpriteNode? ;
    var shots = [SKSpriteNode]();
    var fire = false;
    
    var lastAsteroidCreated = NSDate()
    
    var asteroid1, asteroid2, asteroid3 : SKSpriteNode?;
    
    var points = 14000;
    var pointsLabel = SKLabelNode(fontNamed: "Avenir-Book");
    var asteroids = [SKSpriteNode]();
    var gameViewController:GameViewController?;
    var startMusic:SKAudioNode?;
    var loopMusic:SKAudioNode?;
    var endMusic:SKAudioNode?;
    
    var urlFireAudio:URL?;
    var urlExplAudio:URL?;
    
    var explosionAudio:SKAudioNode?;
    
    open func setGameController(_ gameViewController:GameViewController) -> Void {
        self.gameViewController = gameViewController;
    }
    
    
    override func didMove(to view: SKView) {
        print("Starting Game Scene...")
        aircraft = SKSpriteNode(texture: SKTexture(imageNamed: "aircraft.png"))
        spacebg = SKSpriteNode(texture: SKTexture(imageNamed: "space-bg.jpg"))
        asteroid1 = SKSpriteNode(texture: SKTexture(imageNamed: "asteroids/asteroid-1.png"))
        asteroid2 = SKSpriteNode(texture: SKTexture(imageNamed: "asteroids/asteroid-2.png"))
        asteroid3 = SKSpriteNode(texture: SKTexture(imageNamed: "asteroids/asteroid-3.png"))
        
        if let url = Bundle.main.url(forResource: "music-end", withExtension: "mp3") {
            endMusic = SKAudioNode(url: url)        }
        if let url = Bundle.main.url(forResource: "music-start", withExtension: "mp3") {
            startMusic = SKAudioNode(url: url)
            addChild(startMusic!)
            startMusic?.autoplayLooped=false;
            startMusic?.run(SKAction.play())
            self.run(SKAction.sequence([
                SKAction.wait(forDuration: 16), // Play for 16s;
                SKAction.run ({
                    self.startMusic?.run(SKAction.pause());
                    self.startMusic?.removeFromParent();
                    self.loopMusic?.autoplayLooped = true;
                    self.addChild(self.loopMusic!)
                })
                ]));
        }
        if let url = Bundle.main.url(forResource: "music-loop", withExtension: "mp3") {
            loopMusic = SKAudioNode(url: url)
        }
        urlFireAudio = Bundle.main.url(forResource: "aircraft-laser", withExtension: "mp3");
            
        urlExplAudio =  Bundle.main.url(forResource: "explosion-short", withExtension: "mp3")
        
        spacebg?.zPosition = -1;
        spacebg?.yScale = 2;
        spacebg?.xScale = 2;
        spacebg?.position = CGPoint(x:0,y:self.size.height)
        
        aircraft?.scale(to: CGSize(width: 64, height: 110))
        aircraft?.position = CGPoint(x:0, y: 0)
        
        
        // Physics config
        aircraft?.physicsBody = SKPhysicsBody(rectangleOf: (aircraft?.size)!)
        aircraft?.physicsBody?.isDynamic = false;
        aircraft?.physicsBody?.categoryBitMask = 1;
        aircraft?.physicsBody?.contactTestBitMask = 2;
        
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
                
                fire.name = "fire"
                fire.run(action)
                
                let fireAudio = SKAudioNode(url: self.urlFireAudio!)
                fireAudio.autoplayLooped = false;
                
                self.addChild(fireAudio);
                fireAudio.run(SKAction.sequence([SKAction.play(),SKAction.wait(forDuration: TimeInterval(0.6)),SKAction.run({
                    fireAudio.removeFromParent();
                })]))
            }
        });
        
        
        
        aircraft?.run(SKAction.repeatForever(SKAction.sequence([SKAction.wait(forDuration: TimeInterval(0.5)), fireAction])))
        
        let asteroidAction = SKAction.run ({
            
            let dfAsteroidTime = 15000;
            var diffToCreate:Float = Float(dfAsteroidTime - self.points) * -0.3 / 1000;
            if diffToCreate  >= -1 {
                diffToCreate = -1;
            }
            
            if(Float(self.lastAsteroidCreated.timeIntervalSinceNow) < diffToCreate) {
                
                
                let numAst:UInt32 = arc4random_uniform(4)
                
                var numCreated = 0;
                while(numCreated < Int(numAst)){
                    
                    numCreated = numCreated+1;
                    
                    let asteroidSprite:UInt32 = arc4random_uniform(3) + UInt32(1);
                    
                    let asteroid:SKSpriteNode?;
//                    print("asteroidSprite \(asteroidSprite)")
                    
                    if(asteroidSprite == 1){
                        asteroid = self.asteroid1?.copy() as? SKSpriteNode;
                    } else if(asteroidSprite == 2){
                        asteroid = self.asteroid2?.copy() as? SKSpriteNode;
                    } else if(asteroidSprite == 3){
                        asteroid = self.asteroid3?.copy() as? SKSpriteNode;
                    } else {
                        asteroid = nil;
                    }
                    
                    if(asteroid != nil){
                        
                        // Move asteroid to correct place
                        asteroid?.position = CGPoint(x:CGFloat( arc4random_uniform(UInt32(self.size.width))), y: self.size.height + 20)
                        
                        // Randomize if this asteroid will rotate clockwise.
                        let rotateRandom = arc4random_uniform(2);
                        var rotate1:CGFloat = 0.1;
                        
                        if(rotateRandom == 1){
                            rotate1 = -rotate1;
                        }
                        // Rotate asteroid
                        asteroid?.run(SKAction.repeatForever(SKAction.rotate(byAngle: rotate1, duration: TimeInterval(0.1))))
                        
                        // Create movement to try impact with aicraft
                        asteroid?.run(SKAction.sequence([SKAction.moveTo(y: -30, duration: TimeInterval(arc4random_uniform(15)+4)), SKAction.run {
                            
                            asteroid?.removeFromParent();
                            self.asteroids.remove(at: self.asteroids.index(of: asteroid!)!);
                            
                            }]));
                        
                        asteroid?.name = "asteroid";
                        
                        self.addChild(asteroid!)
                        self.asteroids.append(asteroid!);
                        
                    }
                }
                
                self.lastAsteroidCreated = NSDate();
            }
        });
        
        aircraft?.run(SKAction.repeatForever(SKAction.sequence([SKAction.wait(forDuration: TimeInterval(0.1)), asteroidAction])))
        
        
        // Build label
        pointsLabel.position = CGPoint(x:self.size.width, y: self.size.height - 30)
        pointsLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right;
        
        self.addChild(pointsLabel)
    }
    
    func touchDown(atPoint pos : CGPoint) {
        let move = SKAction.move(to: CGPoint(x:pos.x, y:40), duration: 0);
        aircraft?.run(move);
        self.fire = true
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        let move = SKAction.move(to: CGPoint(x:pos.x, y:40), duration: 0);
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
        
        self.enumerateChildNodes(withName: "fire", using:  {(node:SKNode, stop: UnsafeMutablePointer<ObjCBool>) -> Void in
            self.enumerateChildNodes(withName: "asteroid", using:  {(a:SKNode, stop: UnsafeMutablePointer<ObjCBool>) -> Void in
                if a.intersects(node){
                    self.points = self.points + ( 150 );
                    a.removeFromParent();
                    node.removeFromParent();
                    
                    let explosionAudio = SKAudioNode(url: self.urlExplAudio!)
                    explosionAudio.autoplayLooped = false;
                    self.addChild(explosionAudio);
                    explosionAudio.run(SKAction.sequence([SKAction.play(),SKAction.wait(forDuration: TimeInterval(1)),SKAction.run({
                        explosionAudio.removeFromParent()
                    })]))
                }
            })
        })
        
        
        self.enumerateChildNodes(withName: "asteroid", using:  {(a:SKNode, stop: UnsafeMutablePointer<ObjCBool>) -> Void in
            if a.intersects(self.aircraft!) {
                // DEAD
                self.removeAllActions();
                self.removeAllChildren();
                self.removeFromParent();
                
                let goController:GameOverViewController = (self.gameViewController?.getStoryboard().instantiateViewController(withIdentifier: "GOViewController")) as! GameOverViewController
                
                goController.setPoints(self.points)
//                goController.setPoints(self.points);
                self.gameViewController?.presentController(goController, true)
                
            }
        })
        
        pointsLabel.text = "Pontuação: \(points)";
        
    }
    
}


