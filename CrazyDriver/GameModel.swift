//
//  GameModel.swift
//  CrazyDriver
//
//  Created by Alberti Terence on 26/06/16.
//  Copyright © 2016 TA. All rights reserved.
//

import UIKit

public class GameModel: NSObject {
    
    public enum GameStatus{
        case Paused
        case Running
        case Stopped
    }

    public var carSpeed : Double = 5
    public var maxCarSpeed : Double = 10
    public var minCarSpeed : Double = 4
    public var carAcceleration : Double = 0
    public var time : Timer?
    public var ellapsedMilliseconds = 0
    public var life : Int = 100
    public var gameStatus : GameStatus = GameStatus.Stopped
    public var ticks = 0
    public var carDistance : Double = 0
    public var weaponsModel = WeaponsModel()
    

    
    public func speedRelativeToStreet(objectSpeed : Double) -> Double{
        return self.carSpeed - objectSpeed
    }
    
    

}
