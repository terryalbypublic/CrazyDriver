//
//  GameMainView.swift
//  CrazyDriver
//
//  Created by Alberti Terence on 27/05/16.
//  Copyright © 2016 TA. All rights reserved.
//

import UIKit

public class GameMainView: UIView {
    
    @IBOutlet weak var carImageView: UIImageView!
    var animationClock : CADisplayLink = CADisplayLink()
    var carModel = CarModel()
    var sensorModel = SensorsModel()
    var streetModel = StreetModel()
    var streetViewArray = Array<UIImageView>()
    
    
    public override func drawRect(rect: CGRect) {
        super.drawRect(rect)
    }
    
    public func initializeGame(){
        sensorModel.start()
        carModel.carXPosition = Double(self.bounds.size.width/2)
        initializeStreetViews()
    }
    
    // start animation clock
    public func startAnimationClock(){
        self.animationClock = CADisplayLink(target: self, selector:#selector(nextCicle))
        self.animationClock.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
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
    }
    
    func updateView(){
        carImageView.frame.origin.x = CGFloat(carModel.carXPosition)
        for streetImageView: UIImageView in self.streetViewArray {
            
            streetImageView.frame.origin.y = streetImageView.frame.origin.y+CGFloat(streetModel.speedPerTick)
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
        streetView.backgroundColor = UIColor.clearColor()
        self.insertSubview(streetView, belowSubview: self.carImageView)
        streetViewArray.append(streetView)
        
        
        streetView = makeStreetViewAtPosition(CGRect(x: Int(strOriginX), y: Constants.streetHeight, width: Constants.streetWidth, height: Constants.streetHeight))
        streetView.backgroundColor = UIColor.clearColor()
        self.insertSubview(streetView, belowSubview: self.carImageView)
        streetViewArray.append(streetView)
        
        
        streetView = makeStreetViewAtPosition(CGRect(x: Int(strOriginX), y: Constants.streetHeight*2, width: Constants.streetWidth, height: Constants.streetHeight))
        streetView.backgroundColor = UIColor.clearColor()
        self.insertSubview(streetView, belowSubview: self.carImageView)
        streetViewArray.append(streetView)
    }
    
    func makeStreetViewAtPosition(frame: CGRect) -> UIImageView{
        let streetView = UIImageView(frame: frame)
        streetView.image = UIImage(named: "Street")
        return streetView
    }
    
    // if -1 = false, otherwise you get the id of the array
    func isAStreetDisappered() -> Int{
        for streetImageView: UIImageView in self.streetViewArray {
            if(streetImageView.frame.origin.y == CGFloat(Constants.streetHeight*3)){
                return self.streetViewArray.indexOf(streetImageView)!
            }
        }
        return -1
    }
    
    func moveDownStreet(streetView: UIView){
        streetView.frame.origin.y = CGFloat(-Constants.streetHeight)
    }
    
    func streetOriginX() -> CGFloat{
        return self.frame.size.width / CGFloat(2) - CGFloat(Constants.streetHeight)/2
    }
    
    func updateCarPosition(howMuch: Double, left: Bool){
        // car moving to left
        if(left && self.carModel.carXPosition-howMuch > Double(self.streetOriginX())){
            self.carModel.carXPosition += howMuch
        }
        // car moving to right
        else if(!left && self.carModel.carXPosition+howMuch < Double(self.streetOriginX()+300-self.carImageView.frame.size.width)){
            self.carModel.carXPosition -= howMuch
        }
    }

}
