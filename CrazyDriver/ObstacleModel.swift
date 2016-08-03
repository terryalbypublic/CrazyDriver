//
//  ObstacleModel.swift
//  CrazyDriver
//
//  Created by Alberti Terence on 22/06/16.
//  Copyright © 2016 TA. All rights reserved.
//

import UIKit

public class ObstacleModel: BaseObjectModel {
    
    public enum ObstacleType{
        case RedCar
        case Bomb
    }
    
    public var destroyed = false
    public var explosed = false
    public var obstacleType : ObstacleType?
    
    public init(obstacleType : ObstacleType){
        super.init()
        switch obstacleType {
        case .RedCar:
            self.imageName = "ObstacleRedCar"
            self.frame.origin.x = 300   // todo
            self.frame.origin.y = -100  // todo
            self.speedPerTick = 4       // todo
            self.obstacleType = .RedCar
        default:
            self.imageName = "ObstacleRedCar"
            self.frame.origin.x = 300   // todo
            self.frame.origin.y = -100  // todo
            self.speedPerTick = 4       // todo
            self.obstacleType = .RedCar
        }
    }
}
