//
//  ViewController.swift
//  CrazyDriver
//
//  Created by Alberti Terence on 27/05/16.
//  Copyright © 2016 TA. All rights reserved.
//

import UIKit
import CoreMotion

public class ViewController: UIViewController {
    
    @IBOutlet weak var startPauseButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    // clock
    var animationClock : CADisplayLink = CADisplayLink()
    
    // models
    var carModel = CarModel()
    var sensorModel = SensorsModel()
    var gameModel = GameModel()
    
    // views
    var streetViewArray = Array<UIImageView>()
    var gameMainView : GameMainView? = nil // is set in viewdidload
    
    // obstacles
    var obstacles : [(model: ObstacleModel, view: UIImageView)] = []
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.startGame()
        
    }

    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializeGame(_ obstacles : Array<ObstacleModel>){
        for obstacle in obstacles{
            let imageView = UIImageView(image: UIImage(named: obstacle.imageName))
            imageView.frame.origin.x = CGFloat(obstacle.positionX)
            imageView.frame.origin.y = CGFloat(obstacle.positionY)
            self.obstacles.append((model:obstacle, view: imageView))
        }
        sensorModel.start()
        //carModel.positionY = 10
        carModel.positionX = Double(self.view.bounds.size.width/2)
        let gameMainView = self.view as! GameMainView
        gameMainView.initializeStreetViews()
    }
    
    // start animation clock
    func startAnimationClock(){
        self.animationClock = CADisplayLink(target: self, selector:#selector(nextCicle))
        self.animationClock.add(to: RunLoop.current(), forMode: RunLoopMode.defaultRunLoopMode.rawValue)
        gameMainView?.addObstacleViews(obstacles: obstacles)
    }
    
    // update UI model before redraw
    func nextCicle(){
        updateModel()
        gameMainView?.updateView(carModel:carModel,gameModel:gameModel,obstacles:obstacles)
        gameMainView?.setNeedsDisplay()
    }
    
    func updateModel(){
        // update the car position (maintain the car inside the street)
        
        let updateCarLeft = self.sensorModel.currentRotationY > 0 ? true :false
        let howMuch = updateCarLeft ? self.sensorModel.currentRotationY*(-1) : self.sensorModel.currentRotationY
        updateCarPosition(howMuch*25,left: updateCarLeft)
        updateCarSpeed()
        
        for (model,_) in obstacles{
            model.positionY += gameModel.speedRelativeToStreet(objectSpeed: model.speedPerTick)
        }
    }
    
    func updateCarSpeed(){
        // change car speed with bounds, maxCarSpeed...minCarSpeed
        if(self.gameModel.carSpeed + self.gameModel.carAcceleration >= self.gameModel.minCarSpeed && self.gameModel.carSpeed + self.gameModel.carAcceleration <= self.gameModel.maxCarSpeed){
            self.gameModel.carSpeed += self.gameModel.carAcceleration
        }
        else{
            self.gameModel.carSpeed += (self.gameModel.carSpeed + self.sensorModel.currentRotationX < self.gameModel.minCarSpeed ? self.gameModel.carSpeed - self.gameModel.minCarSpeed : self.sensorModel.currentRotationX)
        }
    }
    
    func updateCarPosition(_ howMuch: Double, left: Bool){
        // car moving to left
        if(left){
            if(self.carModel.positionX+howMuch > Double((gameMainView?.streetOriginX())!)){
                self.carModel.positionX += howMuch
            }
            else{
                self.carModel.positionX = Double((gameMainView?.streetOriginX())!)
            }
        }
            // car moving to right
        else if(!left){
            if(self.carModel.positionX-howMuch < Double((gameMainView?.streetOriginX())!+CGFloat(Constants.streetWidth)-(gameMainView?.carImageView.frame.size.width)!)){
                self.carModel.positionX -= howMuch
            }
            else{
                self.carModel.positionX = Double((gameMainView?.streetOriginX())!+CGFloat(Constants.streetWidth)-(gameMainView?.carImageView.frame.size.width)!)
            }
        }
    }
    
    @IBAction func stopButtonTapped(_ sender: AnyObject) {
        stopGame()
    }

    @IBAction func startPauseButtonTapped(_ sender: AnyObject) {
        if(gameModel.gameStatus == .Stopped){
            startGame()
        }
        else if(gameModel.gameStatus == .Running){
            pauseGame()
        }
        else if(gameModel.gameStatus == .Paused){
            resumeGame()
        }
    }
    
    public func startGame(){
        gameMainView = self.view as? GameMainView
        let obstacle = ObstacleModel()
        obstacle.imageName = "ObstacleRedCar"
        obstacle.positionX = 300
        obstacle.speedPerTick = 4
        
        var obstacles = Array<ObstacleModel>()
        obstacles.append(obstacle)
        
        initializeGame(obstacles)
        
        startAnimationClock()
        gameModel.gameStatus = .Running
        updateButtonsText()
    }
    
    public func pauseGame(){
        self.animationClock.isPaused = true
        gameModel.gameStatus = .Paused
        updateButtonsText()
    }
    
    public func stopGame(){
        gameModel.gameStatus = .Stopped
        self.animationClock.invalidate()
        updateButtonsText()
    }
    
    public func resumeGame(){
        self.animationClock.isPaused = false
        gameModel.gameStatus = .Running
        updateButtonsText()
    }
    
    public func updateButtonsText(){
        if(gameModel.gameStatus == .Running){
            self.startPauseButton.setTitle("Pause", for: UIControlState.focused)
        }
        else if(gameModel.gameStatus == .Stopped){
            self.startPauseButton.setTitle("Start", for: UIControlState.focused)
        }
        else if(gameModel.gameStatus == .Paused){
            self.startPauseButton.setTitle("Resume", for: UIControlState.focused)
        }
    }
    
    @IBAction func brakeButtonTouchedDown(_ sender: AnyObject) {
        self.gameModel.carAcceleration = -0.1
    }
    
    @IBAction func accelerateButtonTouchedDown(_ sender: AnyObject) {
        self.gameModel.carAcceleration = 0.1
    }
    
    @IBAction func brakeButtonTouchCancel(_ sender: AnyObject) {
        self.gameModel.carAcceleration = 0
    }
    
    
    @IBAction func AccelerateButtonTouchCancel(_ sender: AnyObject) {
        self.gameModel.carAcceleration = 0
    }
    
    
    
    
}

