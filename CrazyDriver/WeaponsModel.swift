//
//  WeaponsModel.swift
//  CrazyDriver
//
//  Created by Alberti Terence on 11/08/16.
//  Copyright © 2016 TA. All rights reserved.
//

import UIKit

public class WeaponsModel: NSObject {
    
    public var hasWeapon : Bool {
        get{
            return numberOfAmmunition > 0
        }
    }
    public var numberOfAmmunition = 0

}
