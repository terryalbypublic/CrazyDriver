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
    var obstacles = Array<BaseObjectModel>()
    
    // views
    var streetViewArray = Array<UIImageView>()
    var obstaclesViewArray = Array<UIImageView>()
    @IBOutlet weak var carImageView: UIImageView!
    
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
    public func initializeGame(_ obstacles : Array<BaseObjectModel>){
        createObstacleViews(obstacles)
        self.obstacles = obstacles
        sensorModel.start()
        carModel.positionX = Double(self.bounds.size.width/2)
        initializeStreetViews()
    }
    
    // start animation clock
    public func startAnimationClock(){
        self.animationClock = CADisplayLink(target: self, selector:#selector(nextCicle))
        self.animationClock.add(to: RunLoop.current(), forMode: RunLoopMode.defaultRunLoopMode.rawValue)
    }
    
    private func createObstacleViews(_ obstacles : Array<BaseObjectModel>){
        for obstacle in obstacles{
            let imageView = UIImageView(image: UIImage(named: obstacle.imageName))
            imageView.frame.origin.x = CGFloat(obstacle.positionX)
            imageView.frame.origin.y = CGFloat(obstacle.positionY)
            self.obstaclesViewArray.append(imageView)
            self.addSubview(imageView)
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
        
        for obstacle in obstacles{
            obstacle.positionY += gameModel.speedRelativeToStreet(objectSpeed: obstacle.speedPerTick)
        }
    }
    
    func updateView(){
        carImageView.frame.origin.x = CGFloat(carModel.positionX)
        for streetImageView: UIImageView in self.streetViewArray {
            
            streetImageView.frame.origin.y = streetImageView.frame.origin.y+CGFloat(gameModel.carSpeed)
        }
        
        // update obstacle views based on models
        for index in 0..<obstacles.count{
            self.obstaclesViewArray[index].frame.origin.x = CGFloat(obstacles[index].positionX)
            obstaclesViewArray[index].frame.origin.y = CGFloat(obstacles[index].positionY)
        }
        
        let disappearedStreet = isAStreetDisappered()
        
        if(disappearedStreet > -1){
            moveDownStreet(streetViewArray[disappearedStreet])
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
    
    // if -1 = false, otherwise you get the id of the array
    func isAStreetDisappered() -> Int{
        for streetImageView: UIImageView in self.streetViewArray {
            if(streetImageView.frame.origin.y == CGFloat(Constants.streetHeight*3)){
                return self.streetViewArray.index(of: streetImageView)!
            }
        }
        return -1
    }
    
    func moveDownStreet(_ streetView: UIView){
        streetView.frame.origin.y = CGFloat(-Constants.streetHeight)
    }
    
    func streetOriginX() -> CGFloat{
        return self.frame.size.width / CGFloat(2) - CGFloat(Constants.streetHeight)/2
    }
    
    func updateCarPosition(_ howMuch: Double, left: Bool){
        // car moving to left
        if(left && self.carModel.positionX+howMuch > Double(self.streetOriginX())){
            self.carModel.positionX += howMuch
        }
        // car moving to right
        else if(!left && self.carModel.positionX-howMuch < Double(self.streetOriginX()+300-self.carImageView.frame.size.width)){
            self.carModel.positionX -= howMuch
        }
    }

}
