//
//  GameModel.swift
//  CrazyDriver
//
//  Created by Alberti Terence on 26/06/16.
//  Copyright © 2016 TA. All rights reserved.
//

import UIKit

public class GameModel: NSObject {
    
    
    public var carSpeed : Double = 5
    public var maxCarSpeed : Double = 10
    public var minCarSpeed : Double = 1
    
    public func speedRelativeToStreet(objectSpeed : Double) -> Double{
        return self.carSpeed - objectSpeed
    }

}
