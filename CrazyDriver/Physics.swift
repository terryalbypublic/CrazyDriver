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
    static func isCarCollided(carFrame : CGRect, obstacles : [(model : ObstacleModel,view : UIImageView)]) -> (model : ObstacleModel,view : UIImageView)?{
        for obstacle in obstacles where !obstacle.model.destroyed{
            if (carFrame.intersects(obstacle.model.frame))
            {
                return obstacle
            }
        }
        
        return nil
    }
}
