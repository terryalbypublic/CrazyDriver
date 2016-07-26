//
//  GameMainView.swift
//  CrazyDriver
//
//  Created by Alberti Terence on 27/05/16.
//  Copyright © 2016 TA. All rights reserved.
//

import UIKit
import SpriteKit

public class GameMainView: UIView {
    
    // views
    var streetViewArray = Array<UIImageView>()
    @IBOutlet weak var carImageView: UIImageView!
    
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
    public func updateView(carModel : CarModel, gameModel : GameModel, obstacles : [(model : ObstacleModel,view : UIImageView)]){
        
        // set position of the carview
        carImageView.frame.origin.x = carModel.frame.origin.x
        
        // set the position of the street
        for streetImageView: UIImageView in self.streetViewArray {
            streetImageView.frame.origin.y = streetImageView.frame.origin.y+CGFloat(gameModel.carSpeed)
        }
        
        NSLog("CarSpeed: %f",gameModel.carSpeed)
        
        // update obstacle views
        for (model,view) in obstacles where !model.destroyed{
            view.frame.origin.x = model.frame.origin.x
            view.frame.origin.y = model.frame.origin.y
            removeObstacleIfNeeded(obstacle: (model,view))
        }
        
        let disappearedStreet = isAStreetDisappered()
        
        if(disappearedStreet > -1){
            moveUpStreet(streetViewArray[disappearedStreet])
        }
    }
    
    // MARK: Obstacles
    
    public func addObstacleViews(obstacles : [(model : ObstacleModel,view : UIImageView)]){
        for (_, view) in obstacles{
            self.addSubview(view)
        }
    }
    
    func removeObstacleIfNeeded(obstacle: (model: ObstacleModel, view: UIView)){
        if(obstacle.model.frame.origin.y>500){
            obstacle.view.removeFromSuperview()
            obstacle.model.destroyed = true
        }
    }
    
    // MARK: Street
    
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
    
    public func streetOriginX() -> CGFloat{
        return self.frame.size.width / CGFloat(2) - CGFloat(Constants.streetHeight)/2
    }

}
