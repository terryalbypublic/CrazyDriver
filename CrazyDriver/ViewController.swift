//
//  ViewController.swift
//  CrazyDriver
//
//  Created by Alberti Terence on 27/05/16.
//  Copyright © 2016 TA. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let gameMainView = self.view as! GameMainView
        let obstacle = ObstacleModel()
        obstacle.imageName = "ObstacleRedCar"
        obstacle.obstacleXPosition = 300
        obstacle.speedPerTick = 1
        
        var obstacles = Array<ObstacleModel>()
        obstacles.append(obstacle)
        
        gameMainView.initializeGame(obstacles)
        gameMainView.startAnimationClock()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

