//
//  ViewController.swift
//  CrazyDriver
//
//  Created by Alberti Terence on 27/05/16.
//  Copyright © 2016 TA. All rights reserved.
//

import UIKit
import CoreMotion

public class GameMainViewController: UIViewController {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var lifeBar: UIProgressView!
    @IBOutlet weak var lifeLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var startPauseButton: UIButton!
    @IBOutlet weak var accelerateButton: UIButton!
    @IBOutlet weak var brakeButton: UIButton!
    @IBOutlet weak var cannonButton: UIButton!
    
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
    
    // objectviews
    var objectViews : [(model: ObjectViewModel, view: UIImageView)] = []
    
    // size of the screen
    let screenSize: CGRect = UIScreen.main.bounds
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.startGame()
        self.buildUI()
        
    }

    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func buildUI(){
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func initializeGame(){
        sensorModel.start()
        //carModel.positionY = 10
        carModel.frame.origin.x = CGFloat(self.view.bounds.size.width/2)
        carModel.frame.origin.y = CGFloat(self.view.bounds.size.height-70)
        let gameMainView = self.view as! GameMainView
        
        gameModel = GameModel()
        levelModel = LevelModel.levelModelFromFileName(fileName: "level1")
        gameMainView.initializeStreetViews()
    }
    
    // start animation clock
    func startAnimationClock(){
        self.animationClock = CADisplayLink(target: self, selector:#selector(nextTick))
        self.animationClock.add(to: RunLoop.current, forMode: RunLoopMode(rawValue: RunLoopMode.defaultRunLoopMode.rawValue))
        
        startTime()
    }
    
    // update UI model before redraw
    func nextTick(){
        
        NSLog(String(objectViews.count))
        
        if(gameModel.life <= 0){
            endGameNoMoreLife()
        }
        
        handleEvent(distance: Int(gameModel.carDistance))
        updateModel()
        
        cannonButton.isHidden = !self.gameModel.weaponsModel.hasWeapon
    
        // clean objectViews array
        cleanObjectViewsArray()
        
        // update view
        gameMainView?.updateView(carModel:carModel,gameModel:gameModel,objectViews:objectViews)
        
        // what happen if there are some collisions?
        handleCollisions()
        
        // redraw the view
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
        
        
        for (model,_) in objectViews{
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
        //NSLog(String(gameModel.carDistance))    // todo: remove
        self.updateCarSpeedLabel()
    }
    
    func updateCarPosition(_ howMuch: Double, left: Bool){
        // car moving to left
        if(left){
            if(self.carModel.frame.origin.x+CGFloat(howMuch) > (gameMainView?.streetOriginX())!){
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
        
        presentAlert(title: "Pause", message: "Do you want to continue?", defaultActionTitle: nil, secondActionTitle: "Resume", secondActionHandler: { action in
            self.resumeGame()
            }, thirdActionTitle: "End game", thirdActionHandler: {action in
                
                self.navigationController?.popViewController(animated: true)
                
                return
        })
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
        self.speedLabel.text = String(Int(round(self.gameModel.carSpeed*10)))
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
        self.timeLabel.text = Utility.timeFormatted(totalMilliseconds: gameModel.ellapsedMilliseconds)
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
    
    // MARK - objectViews
    
    private func addObjectView(objectView : ObjectViewModel){
        let imageView = UIImageView(image: UIImage(named: objectView.imageName))
        imageView.frame.origin.x = CGFloat(objectView.frame.origin.x)
        imageView.frame.origin.y = CGFloat(objectView.frame.origin.y)
        objectView.frame = imageView.frame    // get image size
        self.objectViews.append((model:objectView, view: imageView))
        gameMainView?.addObjectView(view: imageView)
    }
    
    // MARK - Tick events
    
    private func handleEvent(distance : Int){
        let data = self.levelModel.data
        
        if(data[levelModel.nextEventId].distance <= distance){
            
            if(data[levelModel.nextEventId].objectViewType == "RedCar"){
                let objectView = ObjectViewModel(objectViewType: .RedCar, originX: screenSize.size.width/2+CGFloat(data[levelModel.nextEventId].originX), originY: -100)
                self.addObjectView(objectView: objectView)
            }
            else if(data[levelModel.nextEventId].objectViewType == "Ammunition"){
                let objectView = ObjectViewModel(objectViewType: .Ammunition, originX: screenSize.size.width/2+CGFloat(data[levelModel.nextEventId].originX), originY: -100)
                self.addObjectView(objectView: objectView)
            }
            else{
                endGameFinished()
            }
            levelModel.nextEventId += 1
        }
    }
    
    // MARK - Time game
    
    private func startTime(){
        gameModel.time = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateEllapsedMilliseconds), userInfo: nil, repeats: true)
    }
    
    public func updateEllapsedMilliseconds(){
        self.gameModel.ellapsedMilliseconds += 100
    }
    
    
    // MARK - Ending of game
    
    func endGameNoMoreLife(){
        self.stopGame()
        gameMainView?.endGame(objectViews: objectViews)
        gameModel.ticks = 0
        
        presentAlert(title: "End", message: "You have no more life, do you want to regame?", defaultActionTitle: nil, secondActionTitle: "Replay", secondActionHandler: { action in
            self.startGame()
            }, thirdActionTitle: "End game", thirdActionHandler: {action in
                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc: UIViewController = storyboard.instantiateViewController(withIdentifier: "MenuViewController") as UIViewController
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .custom
                self.present(vc, animated: true, completion: nil)
                return
        })
    }
    
    func endGameByUser(){
        self.stopGame()
        gameMainView?.endGame(objectViews: objectViews)
        gameModel.ticks = 0
        
        presentAlert(title: "Game end", message: "You stopped the game", defaultActionTitle: "Dismiss")
    }
    
    func endGameFinished(){
        self.stopGame()
        gameMainView?.endGame(objectViews: objectViews)
        gameModel.ticks = 0
        presentAlert(title: "End", message: "You finished the level in "+String(gameModel.ellapsedMilliseconds)+" seconds, do you want to regame?", defaultActionTitle: nil, secondActionTitle: "Replay", secondActionHandler: { action in
            self.startGame()
            }, thirdActionTitle: "End game", thirdActionHandler: {action in
                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc: UIViewController = storyboard.instantiateViewController(withIdentifier: "MenuViewController") as UIViewController
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .custom
                self.present(vc, animated: true, completion: nil)
                return
        })
        saveLevelResult()
    }
    
    private func saveLevelResult(){
        ResultsModel.sharedReference.addResultForLevelId(levelId: levelModel.levelId, milliseconds: gameModel.ellapsedMilliseconds)
    }
    
    // MARK - Alert
    
    func presentAlert(title : String, message : String, defaultActionTitle : String?, secondActionTitle : String? = nil, secondActionHandler : ((UIAlertAction) -> Swift.Void)? = nil, thirdActionTitle : String? = nil, thirdActionHandler : ((UIAlertAction) -> Swift.Void)? = nil){
        
        let alertController = UIAlertController(title: title, message:
            message, preferredStyle: UIAlertControllerStyle.alert)
        
        if(defaultActionTitle != nil){
            alertController.addAction(UIAlertAction(title: defaultActionTitle, style: UIAlertActionStyle.default,handler: nil))
        }
        
        if(secondActionTitle != nil){
            alertController.addAction(UIAlertAction(title: secondActionTitle, style: UIAlertActionStyle.default, handler: secondActionHandler))
        }
        
        if(thirdActionTitle != nil){
            alertController.addAction(UIAlertAction(title: thirdActionTitle, style: UIAlertActionStyle.default, handler: thirdActionHandler))
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK - Cannon
    
    @IBAction func cannonButtonTapped(_ sender: AnyObject) {
        self.gameModel.weaponsModel.numberOfAmmunition -= 1
        
        
        let objectView = ObjectViewModel(objectViewType: .Shot, originX: (carModel.frame.origin.x+carModel.frame.size.width/2)-7, originY: carModel.frame.origin.y-carModel.frame.size.height+13)
        
        addObjectView(objectView: objectView)
        
    }
    
    func cleanObjectViewsArray(){
        
        // new array
        var objectViewsNew : [(model: ObjectViewModel, view: UIImageView)] = []
        
        // select objectViews that are not destroyed
        for objectView in objectViews where !objectView.model.destroyed{
            objectViewsNew.append(objectView)
        }
        // set the new array
        objectViews = objectViewsNew
    }
    
    func handleCollisions(){
        let collidedObjectView = Physics.isCarCollided(carFrame: carModel.frame, objectViews: objectViews)
        if(collidedObjectView != nil && !(collidedObjectView?.model.collided)!){
            self.gameMainView?.collisionWithObjectView(objectView: collidedObjectView!)
            
            if(collidedObjectView?.model.objectViewType == .RedCar){
                self.gameModel.life = self.gameModel.life - 10  // todo value for live
            }
            else if(collidedObjectView?.model.objectViewType == .Ammunition){
                self.gameModel.weaponsModel.numberOfAmmunition += 1
            }
        }
        
        // get objectViews hit by some shots
        let hitObjectViews = Physics.hitObjectViews(objectViews: objectViews)
        if(hitObjectViews.count > 0){
            
            for hitObjectView in hitObjectViews{
                self.gameMainView?.hitObjectView(objectView: hitObjectView)
            }
            
        }
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
}

