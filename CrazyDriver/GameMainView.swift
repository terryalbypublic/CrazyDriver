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
    private var _streetCenterX : CGFloat = 0
    private var _streetOriginX : CGFloat = 0
    var carImageView: UIImageView!
    var backgroundView : UIView!
    var explosionView : UIImageView? = nil
    var explosionTicks = 0
    
    override init(frame : CGRect){
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
    private func setupView(){
        self.backgroundColor = UIColor.init(red: 23, green: 84, blue: 22, alpha: 0.8)
        self.carImageView = UIImageView(image: UIImage(named: "Car"))
        self.addSubview(carImageView)
    }
    
    public func updateView(carModel : CarModel, gameModel : GameModel, objectViews : [(model : ObjectViewModel,view : UIImageView)]){
        
        // update objectView views
        for (model,view) in objectViews where !model.destroyed{
            view.frame.origin.x = model.frame.origin.x
            view.frame.origin.y = model.frame.origin.y
            removeObjectViewIfNeeded(objectView: (model,view))
        }
        
        // set position of the carview
        carImageView.frame.origin.x = carModel.frame.origin.x
        carImageView.frame.origin.y = carModel.frame.origin.y
        
        // set the position of the street
        for streetImageView: UIImageView in self.streetViewArray {
            streetImageView.frame.origin.y = streetImageView.frame.origin.y+CGFloat(gameModel.carSpeed)
        }
        
        if(self.explosionView != nil){
            if(explosionTicks > Constants.explosionDurationInTicks-1){
                self.explosionView?.removeFromSuperview()
                self.explosionView = nil
                explosionTicks = 0
            }
            else{
                explosionTicks += 1
            }
        }
        
        let disappearedStreet = isAStreetDisappered()
        
        if(disappearedStreet > -1){
            moveUpStreet(streetViewArray[disappearedStreet])
        }
        
        carModel.frame = carImageView.frame    // get frame of the view into the model
    }
    
    // MARK: objectViews
    
    public func addObjectView(view : UIImageView){
        self.addSubview(view)
    }
    
    func removeObjectViewIfNeeded(objectView: (model: ObjectViewModel, view: UIView)){
        if(objectView.model.frame.origin.y>500 || objectView.model.frame.origin.y < (-200) || objectView.model.collided){
            objectView.view.removeFromSuperview()
            objectView.model.destroyed = true
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
        streetView.backgroundColor = UIColor.clear
        self.insertSubview(streetView, belowSubview: self.carImageView)
        streetViewArray.append(streetView)
        
        
        streetView = makeStreetViewAtPosition(CGRect(x: Int(strOriginX), y: Constants.streetHeight, width: Constants.streetWidth, height: Constants.streetHeight))
        streetView.backgroundColor = UIColor.clear
        self.insertSubview(streetView, belowSubview: self.carImageView)
        streetViewArray.append(streetView)
        
        
        streetView = makeStreetViewAtPosition(CGRect(x: Int(strOriginX), y: Constants.streetHeight*2, width: Constants.streetWidth, height: Constants.streetHeight))
        streetView.backgroundColor = UIColor.clear
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
    
    // calculate once the streetCenter and streetOrigin X
    private func streetCenterX() -> CGFloat{
        if(_streetCenterX == 0){
            _streetCenterX = self.frame.size.width / CGFloat(2)
        }
        return _streetCenterX
    }
    
    public func streetOriginX() -> CGFloat{
        if(_streetOriginX == 0){
            _streetOriginX = self.frame.size.width / CGFloat(2) - CGFloat(Constants.streetWidth)/2;
        }
        return _streetOriginX
    }
    
    // MARK: Accident or Collision
    
    public func collisionWithObjectView(objectView: (model : ObjectViewModel,view : UIImageView)){
        if(objectView.model.objectViewType == .RedCar){
            accidentAnimation(view: objectView.view)
        }
        else if(objectView.model.objectViewType == .Ammunition){
           takeAmmunitionAnimation(view: objectView.view)
        }
        
        objectView.model.collided = true
    }
    
    // view hit by shot
    public func hitObjectView(objectView: (model : ObjectViewModel,view : UIImageView)){
        if(objectView.model.objectViewType == .RedCar){
            accidentAnimation(view: objectView.view)
        }
        
        objectView.model.collided = true
    }
    
    public func accidentAnimation(view: UIView){
        let explosion = UIImageView(image: UIImage(named: "Explosion"))
        explosion.frame.origin.x = view.frame.origin.x - ((CGFloat(Constants.explosionWidth) - view.frame.size.width) / 2)
        explosion.frame.origin.y = view.frame.origin.y - ((CGFloat(Constants.explosionHeight) - view.frame.size.height) / 2)
        self.addSubview(explosion)
        self.explosionView = explosion
    }
    
    public func takeAmmunitionAnimation(view : UIView){
        
    }
    
    // MARK : End of game
    
    public func endGame(objectViews : [(model : ObjectViewModel,view : UIImageView)]){
        // remove superviews
        explosionView?.removeFromSuperview()
        
        for objectView in objectViews{
            objectView.view.removeFromSuperview()
        }
    }
}
