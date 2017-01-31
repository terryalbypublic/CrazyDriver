//
//  ViewController.swift
//  CrazyDriver
//
//  Created by Alberti Terence on 27/05/16.
//  Copyright © 2016 TA. All rights reserved.
//

import UIKit
import CoreMotion

public class HelpViewController: UIViewController {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var lifeBar: UIProgressView!
    @IBOutlet weak var lifeLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var startPauseButton: UIButton!
    @IBOutlet weak var accelerateButton: UIButton!
    @IBOutlet weak var brakeButton: UIButton!
    @IBOutlet weak var cannonButton: UIButton!
    
    // arrows
    @IBOutlet weak var brakeArrow: UIImageView!
    @IBOutlet weak var accelerateArrow: UIImageView!
    @IBOutlet weak var cannonArrow: UIImageView!
    @IBOutlet weak var timeArrow: UIImageView!
    @IBOutlet weak var lifeArrow: UIImageView!
    
    // arrows Labels
    @IBOutlet weak var cannonArrowLabel: UILabel!
    @IBOutlet weak var accelerateArrowLabel: UILabel!
    @IBOutlet weak var brakeArrowLabel: UILabel!
    @IBOutlet weak var timeArrowLabel: UILabel!
    @IBOutlet weak var lifeArrowLabel: UILabel!
    @IBOutlet weak var iphoneArrowLabel: UILabel!
    
    
    // iphone
    @IBOutlet weak var iphoneImage: UIImageView!
    
    var iPhoneImageIsRotating : Bool = false
    
    
    // clock
    var animationClock : CADisplayLink = CADisplayLink()
    
    // models
    var carModel = CarModel()
    var sensorModel = SensorsModel()
    var gameModel = GameModel()
    var levelModel = LevelModel.levelModelFromFileName(fileName: "level1")
    
    // weapon
    var weaponsAlreadyAppeared = false
    
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
        
        self.buildUI()
        self.startGame()
        
    }
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func buildUI(){
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func initializeGame(){
        hideAllControls()
        sensorModel.start()
        //carModel.positionY = 10
        carModel.frame.origin.x = CGFloat(self.view.bounds.size.width/2)
        carModel.frame.origin.y = CGFloat(self.view.bounds.size.height-70)
        let gameMainView = self.view as! GameMainView
        
        gameModel = GameModel()
        levelModel = LevelModel.levelModelFromFileName(fileName: "level1")
        gameMainView.initializeStreetViews()
    }
    
    func hideAllControls(){
        
        brakeArrow.isHidden = true
        accelerateArrow.isHidden = true
        timeArrow.isHidden = true
        lifeArrow.isHidden = true
        cannonArrow.isHidden = true
        
        brakeArrowLabel.isHidden = true
        accelerateArrowLabel.isHidden = true
        timeArrowLabel.isHidden = true
        lifeArrowLabel.isHidden = true
        cannonArrowLabel.isHidden = true
        iphoneArrowLabel.isHidden = true
        
        timeLabel.isHidden = true
        lifeBar.isHidden = true
        lifeLabel.isHidden = true
        accelerateButton.isHidden = true
        brakeButton.isHidden = true
        iphoneImage.isHidden = true
        
        weaponsAlreadyAppeared = false
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
        }, thirdActionTitle: "End tutorial", thirdActionHandler: {action in
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
    
    
    private func addObjectViewRelativeToStreet(objectView : ObjectViewModel){
        let imageView = UIImageView(image: UIImage(named: objectView.imageName))
        imageView.frame.origin.x = (gameMainView?.streetOriginX())! + CGFloat(objectView.frame.origin.x)
        imageView.frame.origin.y = CGFloat(objectView.frame.origin.y)
        objectView.frame = imageView.frame    // get image size
        self.objectViews.append((model:objectView, view: imageView))
        gameMainView?.addObjectView(view: imageView)
    }
    
    // MARK - Tick events
    
    private func handleEvent(distance : Int){
        
        if(gameModel.ellapsedMilliseconds > 3000 && gameModel.ellapsedMilliseconds < 7000){
            // show helps for accelarate, and brake
            accelerateButton.isHidden = false
            brakeButton.isHidden = false
            
            accelerateArrow.isHidden = false
            brakeArrow.isHidden = false
            
            accelerateArrowLabel.isHidden = false
            brakeArrowLabel.isHidden = false
        }
        
        else if(gameModel.ellapsedMilliseconds > 7000 && gameModel.ellapsedMilliseconds < 16000){
            // show how to go left and right
            
            accelerateArrow.isHidden = true
            brakeArrow.isHidden = true
            
            accelerateArrowLabel.isHidden = true
            brakeArrowLabel.isHidden = true
            
            
            // animate iphone
            iphoneImage.isHidden = false
            iphoneArrowLabel.isHidden = false
            
            if(!iPhoneImageIsRotating){
                iPhoneImageIsRotating = true
                rotateIphoneClockwise(clockwise: true)
            }
            
        }
        
        else if(gameModel.ellapsedMilliseconds > 16000 && gameModel.ellapsedMilliseconds < 23000){
            
            iphoneImage.isHidden = true
            iphoneArrowLabel.isHidden = true
            iPhoneImageIsRotating = false
            
            // show how to fire
            
            if(cannonButton.isHidden && (distance/100) % 4 == 0 && !weaponsAlreadyAppeared){
                // set some weapons on the road
                addWeaponOnStreet(positionX: 0, originY: -145)
                addWeaponOnStreet(positionX: 25, originY: -150)
                addWeaponOnStreet(positionX: 50, originY: -155)
                addWeaponOnStreet(positionX: 75, originY: -160)
                addWeaponOnStreet(positionX: 100, originY: -165)
                addWeaponOnStreet(positionX: 125, originY: -170)
                addWeaponOnStreet(positionX: 150, originY: -175)
                addWeaponOnStreet(positionX: 175, originY: -180)
                addWeaponOnStreet(positionX: 200, originY: -185)
                addWeaponOnStreet(positionX: 225, originY: -190)
                addWeaponOnStreet(positionX: 250, originY: -195)
                addWeaponOnStreet(positionX: 275, originY: -200)
                
                weaponsAlreadyAppeared = true
            }
            
            else if(!cannonButton.isHidden){
                // show the arrow for the cannon
                cannonArrow.isHidden = false
                cannonArrowLabel.isHidden = false
            }
        }
        
        
        else if(gameModel.ellapsedMilliseconds > 23000 && gameModel.ellapsedMilliseconds < 27000){
            // show the time
            
            cannonArrow.isHidden = true
            cannonArrowLabel.isHidden = true
            
            timeLabel.isHidden = false
            timeArrow.isHidden = false
            timeArrowLabel.isHidden = false
        }
        
        else if(gameModel.ellapsedMilliseconds > 27000 && gameModel.ellapsedMilliseconds < 33000){
            // show the life
            timeArrow.isHidden = true
            timeArrowLabel.isHidden = true

            lifeBar.isHidden = false
            lifeLabel.isHidden = false
            lifeArrow.isHidden = false
            lifeArrowLabel.isHidden = false
        }
        
        else if(gameModel.ellapsedMilliseconds > 33000){
            self.stopGame()
            gameMainView?.endGame(objectViews: objectViews)
            gameModel.ticks = 0
            presentAlert(title: "That's all", message: "Congratulations, now you can drive! The tutorial is finished, do you want to play, or repeat the tutorial?", defaultActionTitle: nil, secondActionTitle: "Repeat", secondActionHandler: { action in
                self.startGame()
            }, thirdActionTitle: "Play", thirdActionHandler: {action in
                self.navigationController?.popViewController(animated: true)
                return
            })
        }
    }
    
    // MARK - Animate iPhone
    private func animateIphone(){
        rotateIphoneClockwise(clockwise: true)
    }
    
    private func rotateIphoneClockwise(clockwise : Bool, howManyTimes : Int = 5){
        UIView.animate(withDuration: 2.0, animations: {
            if(clockwise){
                self.iphoneImage.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 4)
            }
            else{
                self.iphoneImage.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 4)
            }
        }, completion: {(Bool) in
            if(howManyTimes>0){
                self.rotateIphoneClockwise(clockwise: !clockwise, howManyTimes: howManyTimes-1)
            }
        })
    }
    
    private func addWeaponOnStreet(positionX : Int, originY : Int = -100){
        let objectView = ObjectViewModel(objectViewType: .Ammunition, originX: CGFloat(positionX), originY: CGFloat(originY))
        self.addObjectViewRelativeToStreet(objectView: objectView)
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
            self.navigationController?.popViewController(animated: true)
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
            self.navigationController?.popViewController(animated: true)
            return
        })
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
    
    
    
}

