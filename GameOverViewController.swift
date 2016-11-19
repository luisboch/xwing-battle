//
//  GameOverViewController.swift
//  xwing-fight
//
//  Created by PUCPR on 19/11/16.
//  Copyright © 2016 puc-dev. All rights reserved.
//

import Foundation
import GameplayKit
import UIKit

class GameOverViewController:UIViewController{
    @IBOutlet weak var label: UILabel!
    var points:Int?;
    override func viewDidLoad() {
        label.text="\(points!)"
    }
    open func setPoints(_ val:Int ) -> Void{
        print(val)
        points = val
    }
}
