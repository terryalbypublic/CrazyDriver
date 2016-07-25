//
//  CarModel.swift
//  CrazyDriver
//
//  Created by Alberti Terence on 30/05/16.
//  Copyright © 2016 TA. All rights reserved.
//

import UIKit


public class CarModel: BaseObjectModel {
    
    public enum AccelerationStatus{
        case Braking
        case Accelerating
        case BrakingAndAccelering
        case Nothing
    }
    
    public var accelerationStatus : AccelerationStatus = .Nothing
}
