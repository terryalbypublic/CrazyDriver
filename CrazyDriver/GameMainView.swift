//
//  GameMainView.swift
//  CrazyDriver
//
//  Created by Alberti Terence on 27/05/16.
//  Copyright © 2016 TA. All rights reserved.
//

import UIKit

public class GameMainView: UIView {
    
    // clock
    var animationClock : CADisplayLink = CADisplayLink()
    
    // models
    var carModel = CarModel()
    var sensorModel = SensorsModel()
    var gameModel = GameModel()
    
    // obstacles
    var obstacles : [(model: BaseObjectModel, view: UIImageView)] = []
    
    // views
    var streetViewArray = Array<UIImageView>()
    @IBOutlet weak var carImageView: UIImageView!
    
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
    public func initializeGame(_ obstacles : Array<BaseObjectModel>){
        for obstacle in obstacles{
            let imageView = UIImageView(image: UIImage(named: obstacle.imageName))
            imageView.frame.origin.x = CGFloat(obstacle.positionX)
            imageView.frame.origin.y = CGFloat(obstacle.positionY)
            self.obstacles.append((model:obstacle, view: imageView))
        }
        sensorModel.start()
        carModel.positionX = Double(self.bounds.size.width/2)
        initializeStreetViews()
    }
    
    // start animation clock
    public func startAnimationClock(){
        self.animationClock = CADisplayLink(target: self, selector:#selector(nextCicle))
        self.animationClock.add(to: RunLoop.current(), forMode: RunLoopMode.defaultRunLoopMode.rawValue)
        addObstacleViews()
    }
    
    private func addObstacleViews(){
        for (_, view) in obstacles{
            self.addSubview(view)
        }
    }
    
    // update UI model before redraw
    func nextCicle(){
        updateModel()
        updateView()
        setNeedsDisplay()
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
    
    func updateView(){
        carImageView.frame.origin.x = CGFloat(carModel.positionX)
        for streetImageView: UIImageView in self.streetViewArray {
            
            streetImageView.frame.origin.y = streetImageView.frame.origin.y+CGFloat(gameModel.carSpeed)
        }
        
        // update obstacle views
        for (model,view) in obstacles{
            view.frame.origin.x = CGFloat(model.positionX)
            view.frame.origin.y = CGFloat(model.positionY)
        }
        
        let disappearedStreet = isAStreetDisappered()
        
        if(disappearedStreet > -1){
            moveUpStreet(streetViewArray[disappearedStreet])
        }
    }
    
    func updateCarSpeed(){
        // change car speed with bounds, maxCarSpeed...minCarSpeed
        if(self.sensorModel.currentRotationX > 0){
            self.gameModel.carSpeed += (self.gameModel.carSpeed + self.sensorModel.currentRotationX > self.gameModel.maxCarSpeed ? self.gameModel.maxCarSpeed - self.gameModel.carSpeed  : self.sensorModel.currentRotationX)
        }
        else{
            self.gameModel.carSpeed += (self.gameModel.carSpeed + self.sensorModel.currentRotationX < self.gameModel.minCarSpeed ? self.gameModel.carSpeed - self.gameModel.minCarSpeed : self.sensorModel.currentRotationX)
        }
    }
    
    func initializeStreetViews(){
        
        self.carImageView.frame.origin.y = self.frame.size.height - self.carImageView.frame.height
        
        let strOriginX = streetOriginX()
        var streetView = makeStreetViewAtPosition(CGRect(x: Int(strOriginX), y: -Constants.streetHeight, width: Constants.streetWidth, height: Constants.streetHeight))
        self.insertSubview(streetView, belowSubview: self.carImageView)
        streetViewArray.append(streetView)
        
        streetView = makeStreetViewAtPosition(CGRect(x: Int(strOriginX), y: 0, width: Constants.streetWidth, height: Constants.streetHeight))
        streetView.backgroundColor = UIColor.clear()
        self.insertSubview(streetView, belowSubview: self.carImageView)
        streetViewArray.append(streetView)
        
        
        streetView = makeStreetViewAtPosition(CGRect(x: Int(strOriginX), y: Constants.streetHeight, width: Constants.streetWidth, height: Constants.streetHeight))
        streetView.backgroundColor = UIColor.clear()
        self.insertSubview(streetView, belowSubview: self.carImageView)
        streetViewArray.append(streetView)
        
        
        streetView = makeStreetViewAtPosition(CGRect(x: Int(strOriginX), y: Constants.streetHeight*2, width: Constants.streetWidth, height: Constants.streetHeight))
        streetView.backgroundColor = UIColor.clear()
        self.insertSubview(streetView, belowSubview: self.carImageView)
        streetViewArray.append(streetView)
    }
    
    func makeStreetViewAtPosition(_ frame: CGRect) -> UIImageView{
        let streetView = UIImageView(frame: frame)
        streetView.image = UIImage(named: "Street")
        return streetView
    }
    
    // if -1 = false, otherwise you get the id of the disapperead street
    func isAStreetDisappered() -> Int{
        for streetImageView: UIImageView in self.streetViewArray {
            if(streetImageView.frame.origin.y >= CGFloat(Constants.streetHeight*3)){
                return self.streetViewArray.index(of: streetImageView)!
            }
        }
        return -1
    }
    
    // take a piece of street, and set on the top of the view
    func moveUpStreet(_ streetView: UIView){
        
        let newYPosition = CGFloat(-Constants.streetHeight) + streetView.frame.origin.y - CGFloat(Constants.streetHeight)*3
        streetView.frame.origin.y = CGFloat(newYPosition)
    }
    
    func streetOriginX() -> CGFloat{
        return self.frame.size.width / CGFloat(2) - CGFloat(Constants.streetHeight)/2
    }
    
    func updateCarPosition(_ howMuch: Double, left: Bool){
        // car moving to left
        if(left){
            if(self.carModel.positionX+howMuch > Double(self.streetOriginX())){
                self.carModel.positionX += howMuch
            }
            else{
                self.carModel.positionX = Double(self.streetOriginX())
            }
        }
        // car moving to right
        else if(!left){
            if(self.carModel.positionX-howMuch < Double(self.streetOriginX()+CGFloat(Constants.streetWidth)-self.carImageView.frame.size.width)){
                self.carModel.positionX -= howMuch
            }
            else{
                self.carModel.positionX = Double(self.streetOriginX()+CGFloat(Constants.streetWidth)-self.carImageView.frame.size.width)
            }
        }
    }

}
