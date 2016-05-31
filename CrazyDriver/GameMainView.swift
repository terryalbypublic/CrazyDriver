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
    var streetViewArray = Array<UIImageView>()
    
    
    public override func drawRect(rect: CGRect) {
        super.drawRect(rect)
    }
    
    public func initializeGame() -> Void{
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
        carModel.carXPosition -= self.sensorModel.currentRotationY*25
    }
    
    func updateView(){
        carImageView.frame.origin.x = CGFloat(carModel.carXPosition)
        for streetImageView: UIImageView in self.streetViewArray {
            streetImageView.frame.origin.y = streetImageView.frame.origin.y+5
        }
        
        let disappearedStreet = isAStreetDisappered()
        
        if(disappearedStreet > -1){
            moveDownStreet(streetViewArray[disappearedStreet])
        }
    }
    
    func initializeStreetViews(){
        
        self.carImageView.frame.origin.y = self.frame.size.height - self.carImageView.frame.height
        
        var streetView = makeStreetViewAtPosition(CGRect(x: streetOriginX(), y: -300, width: 300, height: 300))
        self.insertSubview(streetView, belowSubview: self.carImageView)
        streetViewArray.append(streetView)
        
        streetView = makeStreetViewAtPosition(CGRect(x: streetOriginX(), y: 0, width: 300, height: 300))
        streetView.backgroundColor = UIColor.clearColor()
        self.insertSubview(streetView, belowSubview: self.carImageView)
        streetViewArray.append(streetView)
        
        
        streetView = makeStreetViewAtPosition(CGRect(x: streetOriginX(), y: 300, width: 300, height: 300))
        streetView.backgroundColor = UIColor.clearColor()
        self.insertSubview(streetView, belowSubview: self.carImageView)
        streetViewArray.append(streetView)
        
        
        streetView = makeStreetViewAtPosition(CGRect(x: streetOriginX(), y: 600, width: 300, height: 300))
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
            if(streetImageView.frame.origin.y == 900){
                return self.streetViewArray.indexOf(streetImageView)!
            }
        }
        return -1
    }
    
    func moveDownStreet(streetView: UIView){
        streetView.frame.origin.y = -300
    }
    
    func streetOriginX() -> CGFloat{
        return self.frame.size.width / CGFloat(2) - 150
    }

}
