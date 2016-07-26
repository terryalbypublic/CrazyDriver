//
//  BaseObjectModel.swift
//  CrazyDriver
//
//  Created by Alberti Terence on 26/06/16.
//  Copyright © 2016 TA. All rights reserved.
//

import UIKit

public class BaseObjectModel: NSObject {
    public var imageName : String = ""
    public var frame : CGRect = CGRect(x: 0,y: 0,width: 0,height: 0)
    public var speedPerTick : Double = 0    // relative to the street movements

}
