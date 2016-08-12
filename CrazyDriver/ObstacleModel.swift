//
//  ObstacleModel.swift
//  CrazyDriver
//
//  Created by Alberti Terence on 22/06/16.
//  Copyright © 2016 TA. All rights reserved.
//

import UIKit

public class ObjectViewModel: BaseObjectModel {
    
    public enum ObjectType : Int{
        case RedCar
        case Bomb
        case Ammunition
        case FinishLevel
        case Shot
        case None
    }
    
    public var destroyed = false
    public var collided = false
    public var objectViewType : ObjectType = ObjectType.None
    
    public init(objectViewType : ObjectType){
        super.init()
        switch objectViewType {
        case .RedCar:
            self.imageName = "ObstacleRedCar"
            self.frame.origin.x = 300   // todo
            self.frame.origin.y = -100  // todo
            self.speedPerTick = 1       // todo
            self.objectViewType = .RedCar
        case .Ammunition:
            self.imageName = "Ammunition"
            self.frame.origin.x = 400   // todo
            self.frame.origin.y = -100  // todo
            self.speedPerTick = 0       // todo
            self.objectViewType = .Ammunition
        case .Shot:
            self.imageName = "Ammunition"
            self.frame.origin.x = 400   // todo
            self.frame.origin.y = 150  // todo
            self.speedPerTick = 30       // todo
            self.objectViewType = .Ammunition
        default:
            self.imageName = "ObstacleRedCar"
            self.frame.origin.x = 300   // todo
            self.frame.origin.y = -100  // todo
            self.speedPerTick = 4       // todo
            self.objectViewType = .RedCar
        }
    }
}
