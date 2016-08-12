//
//  Physics.swift
//  CrazyDriver
//
//  Created by Alberti Terence on 26/07/16.
//  Copyright © 2016 TA. All rights reserved.
//

import UIKit

class Physics: NSObject {

    // collision
    static func isCarCollided(carFrame : CGRect, objectViews : [(model : ObjectViewModel,view : UIImageView)]) -> (model : ObjectViewModel,view : UIImageView)?{
        for objectView in objectViews where !objectView.model.destroyed{
            if (carFrame.intersects(objectView.model.frame))
            {
                return objectView
            }
        }
        
        return nil
    }
}
