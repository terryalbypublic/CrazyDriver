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
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var lifeBar: UIProgressView!
    @IBOutlet weak var lifeLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var startPauseButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var accelerateButton: UIButton!
    @IBOutlet weak var brakeButton: UIButton!
    
    // clock
    var animationClock : CADisplayLink = CADisplayLink()
    
    // models
    var carModel = CarModel()
    var sensorModel = SensorsModel()
    var gameModel = GameModel()
    var levelModel = LevelModel.levelModelFromFileName(fileName: "level1")
    
    // views
    var streetViewArray = Array<UIImageView>()
    var gameMainView : GameMainView?
    
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
    
    func initializeGame(){
        sensorModel.start()
        //carModel.positionY = 10
        carModel.frame.origin.x = CGFloat(self.view.bounds.size.width/2)
        carModel.frame.origin.y = CGFloat(self.view.bounds.size.height-150)
        let gameMainView = self.view as! GameMainView
        
        gameModel = GameModel()
        gameMainView.initializeStreetViews()
    }
    
    // start animation clock
    func startAnimationClock(){
        self.animationClock = CADisplayLink(target: self, selector:#selector(nextTick))
        self.animationClock.add(to: RunLoop.current(), forMode: RunLoopMode.defaultRunLoopMode.rawValue)
        
        startTime()
    }
    
    // update UI model before redraw
    func nextTick(){
        
        if(gameModel.life <= 0){
            endGameNoMoreLife()
        }
        
        handleEvent(distance: Int(gameModel.carDistance))
        updateModel()
        gameMainView?.updateView(carModel:carModel,gameModel:gameModel,obstacles:obstacles)
       let collidedObstacle = Physics.isCarCollided(carFrame: carModel.frame, obstacles: obstacles)
        if(collidedObstacle != nil && !(collidedObstacle?.model.explosed)!){
            self.gameMainView?.accidentWithObstacle(obstacle: collidedObstacle!)
            
            self.gameModel.life = self.gameModel.life - 10  // todo value for live
        }
        gameMainView?.setNeedsDisplay()
        
        self.gameModel.ticks += 1
    }
    
    func updateModel(){
        // update the car position (maintain the car inside the street)
        
        let updateCarLeft = self.sensorModel.currentRotationY > 0 ? true :false
        let howMuch = updateCarLeft ? self.sensorModel.currentRotationY*(-1) : self.sensorModel.currentRotationY
        updateCarPosition(howMuch*25,left: updateCarLeft)
        updateCarSpeed()
        updateLife()
        updateTimeLabel()
        
        
        for (model,_) in obstacles{
            model.frame.origin.y = CGFloat(gameModel.speedRelativeToStreet(objectSpeed: model.speedPerTick))+model.frame.origin.y
        }
    }
    
    func updateLife(){
        updateLifeLabel()
    }
    
    func updateCarSpeed(){
        // change car speed with bounds, maxCarSpeed...minCarSpeed
        if(self.gameModel.carSpeed + self.gameModel.carAcceleration >= self.gameModel.minCarSpeed && self.gameModel.carSpeed + self.gameModel.carAcceleration <= self.gameModel.maxCarSpeed){
            self.gameModel.carSpeed += self.gameModel.carAcceleration
        }
        
        // increment cardistance
        gameModel.carDistance = gameModel.carDistance + gameModel.carSpeed
        NSLog(String(gameModel.carDistance))    // todo: remove
        self.updateCarSpeedLabel()
    }
    
    func updateCarPosition(_ howMuch: Double, left: Bool){
        // car moving to left
        if(left){
            if(self.carModel.frame.origin.x+CGFloat(howMuch) > gameMainView?.streetOriginX()){
                self.carModel.frame.origin.x += CGFloat(howMuch)
            }
            else{
                self.carModel.frame.origin.x = (gameMainView?.streetOriginX())!
            }
        }
            // car moving to right
        else if(!left){
            if(self.carModel.frame.origin.x-CGFloat(howMuch) < CGFloat((gameMainView?.streetOriginX())!+CGFloat(Constants.streetWidth)-(gameMainView?.carImageView.frame.size.width)!)){
                self.carModel.frame.origin.x -= CGFloat(howMuch)
            }
            else{
                self.carModel.frame.origin.x = CGFloat((gameMainView?.streetOriginX())!+CGFloat(Constants.streetWidth)-(gameMainView?.carImageView.frame.size.width)!)
            }
        }
    }
    
    // MARK: Game flow
    
    @IBAction func stopButtonTapped(_ sender: AnyObject) {
        stopGame()
        endGameByUser()
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
        
        initializeGame()

        startAnimationClock()
        gameModel.gameStatus = .Running
        updateButtonsText()
    }
    
    public func pauseGame(){
        self.animationClock.isPaused = true
        gameModel.time?.invalidate()
        gameModel.gameStatus = .Paused
        updateButtonsText()
    }
    
    public func stopGame(){
        gameModel.gameStatus = .Stopped
        self.animationClock.invalidate()
        gameModel.time?.invalidate()
        updateButtonsText()
    }
    
    public func resumeGame(){
        self.animationClock.isPaused = false
        startTime()
        gameModel.gameStatus = .Running
        updateButtonsText()
    }
    
    // MARK: Textlabels
    
    public func updateCarSpeedLabel(){
        self.speedLabel.text = String(round(self.gameModel.carSpeed*10))
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
    
    public func updateLifeLabel(){
        self.lifeLabel.text = String(self.gameModel.life) + "%"
        self.lifeBar.setProgress(Float(self.gameModel.life)/Float(100.0), animated: true)
    }
    
    public func updateTimeLabel(){
        self.timeLabel.text = timeFormatted(totalSeconds: gameModel.ellapsedSeconds)
    }
    
    // MARK: Acceleration
    
    private func isAccelerating() -> Bool{
        return self.accelerateButton.isTouchInside
    }
    
    private func isBraking() -> Bool{
        return self.brakeButton.isTouchInside
    }
    
    // it will increase the car's speed
    private func accelerate(howMuch : Double){
        self.gameModel.carAcceleration = howMuch
    }
    
    @IBAction func brakeButtonTouchedDown(_ sender: AnyObject) {
        if(self.isAccelerating()){
            self.carModel.accelerationStatus = .BrakingAndAccelering
        }
        else{
            self.carModel.accelerationStatus = .Braking
        }
        
        setAcceleration()
    }
    
    @IBAction func accelerateButtonTouchedDown(_ sender: AnyObject) {
        if(self.isBraking()){
            self.carModel.accelerationStatus = .BrakingAndAccelering
        }
        else{
            self.carModel.accelerationStatus = .Accelerating
        }

        setAcceleration()
    }
    
    @IBAction func accelerateButtonTouchReleased(_ sender: AnyObject) {
        if(self.isBraking()){
            self.carModel.accelerationStatus = .Braking
        }
        else{
            self.carModel.accelerationStatus = .Nothing
        }
        
        setAcceleration()
    }
    
    @IBAction func brakeButtonTouchReleased(_ sender: AnyObject) {
        if(self.isAccelerating()){
            self.carModel.accelerationStatus = .Accelerating
        }
        else{
            self.carModel.accelerationStatus = .Nothing
        }
        
        setAcceleration()
    }
    
    private func setAcceleration(){
        switch self.carModel.accelerationStatus {
        case .Accelerating:
            self.accelerate(howMuch: 0.1)
        case .Braking:
            self.accelerate(howMuch: -0.1)
        case .BrakingAndAccelering:
            self.accelerate(howMuch: 0.05)
        default:
            self.accelerate(howMuch: 0)
        }
    }
    
    // MARK - Obstacles
    
    private func addObstacle(obstacle : ObstacleModel){
        let imageView = UIImageView(image: UIImage(named: obstacle.imageName))
        imageView.frame.origin.x = CGFloat(obstacle.frame.origin.x)
        imageView.frame.origin.y = CGFloat(obstacle.frame.origin.y)
        obstacle.frame = imageView.frame    // get image size
        self.obstacles.append((model:obstacle, view: imageView))
        gameMainView?.addObstacleView(view: imageView)
    }
    
    // MARK - Tick events
    
    private func handleEvent(distance : Int){
        let data = self.levelModel.data
        
        if(data[levelModel.nextEventId].distance <= distance){
            
            if(data[levelModel.nextEventId].obstacleType == "RedCar"){
                let obstacle = ObstacleModel(obstacleType: .RedCar)
                self.addObstacle(obstacle: obstacle)
            }
            else{
                endGameByUser()
            }
            levelModel.nextEventId += 1
        }
    }
    
    // MARK - Time game
    
    private func startTime(){
        gameModel.time = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateEllapsedSeconds), userInfo: nil, repeats: true)
    }
    
    public func updateEllapsedSeconds(){
        self.gameModel.ellapsedSeconds += 1
    }
    
    func timeFormatted(totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    // MARK - Ending of game
    
    func endGameNoMoreLife(){
        self.stopGame()
        gameMainView?.endGame(obstacles: obstacles)
        gameModel.ticks = 0
        
        presentAlert(title: "Game end", message: "You have no more life", actionTitle: "Dismiss")
    }
    
    func endGameByUser(){
        self.stopGame()
        gameMainView?.endGame(obstacles: obstacles)
        gameModel.ticks = 0
        
        presentAlert(title: "Game end", message: "You stopped the game", actionTitle: "Dismiss")
    }
    
    // MARK - Alert
    
    func presentAlert(title : String, message : String, actionTitle : String){
        
        let alertController = UIAlertController(title: title, message:
            message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: actionTitle, style: UIAlertActionStyle.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}

