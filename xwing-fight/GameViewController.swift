//
//  GameViewController.swift
//  xwing-fight
//
//  Created by puc-dev on 10/23/16.
//  Copyright © 2016 puc-dev. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let view = self.view as! SKView?
        // Load the SKScene from 'GameScene.sks'
        let scene = GameScene();
        scene.setGameController(self)
        // Set the scale mode to scale to fit the window
        scene.scaleMode = .resizeFill
        
        view!.presentScene(scene)
        
        view!.ignoresSiblingOrder = true
        
        view!.showsFPS = true
        view!.showsNodeCount = true
        
        
        
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    open func  getStoryboard() -> UIStoryboard{
        return self.storyboard!
    }
    open func presentController(_ view:UIViewController, _ animated:Bool) -> Void{
        self.present(view, animated:animated, completion:nil)
    }
}
