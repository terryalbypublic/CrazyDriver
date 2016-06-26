//
//  GameModel.swift
//  CrazyDriver
//
//  Created by Alberti Terence on 26/06/16.
//  Copyright © 2016 TA. All rights reserved.
//

import UIKit

public class GameModel: NSObject {
    
    
    public let carSpeed : Double = 5
    
    public func speedRelativeToStreet(objectSpeed : Double) -> Double{
        return self.carSpeed - objectSpeed
    }

}
