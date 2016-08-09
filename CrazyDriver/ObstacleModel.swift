//
//  ObstacleModel.swift
//  CrazyDriver
//
//  Created by Alberti Terence on 22/06/16.
//  Copyright © 2016 TA. All rights reserved.
//

import UIKit

public class ObstacleModel: BaseObjectModel {
    
    public enum ObstacleType : Int{
        case RedCar
        case Bomb
        case Ammunition
        case FinishLevel
        case None
    }
    
    public var destroyed = false
    public var collided = false
    public var obstacleType : ObstacleType = ObstacleType.None
    
    public init(obstacleType : ObstacleType){
        super.init()
        switch obstacleType {
        case .RedCar:
            self.imageName = "ObstacleRedCar"
            self.frame.origin.x = 300   // todo
            self.frame.origin.y = -100  // todo
            self.speedPerTick = 1       // todo
            self.obstacleType = .RedCar
        case .Ammunition:
            self.imageName = "Ammunition"
            self.frame.origin.x = 400   // todo
            self.frame.origin.y = -100  // todo
            self.speedPerTick = 0       // todo
            self.obstacleType = .Ammunition
        default:
            self.imageName = "ObstacleRedCar"
            self.frame.origin.x = 300   // todo
            self.frame.origin.y = -100  // todo
            self.speedPerTick = 4       // todo
            self.obstacleType = .RedCar
        }
    }
}
