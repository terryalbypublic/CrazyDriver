//
//  Physics.swift
//  CrazyDriver
//
//  Created by Alberti Terence on 26/07/16.
//  Copyright © 2016 TA. All rights reserved.
//

import UIKit

class Physics: NSObject {

    // collision, return the ObjectView that has collided with the car, todo: what if the car collided with two views at the same time?
    static func isCarCollided(carFrame : CGRect, objectViews : [(model : ObjectViewModel,view : UIImageView)]) -> (model : ObjectViewModel,view : UIImageView)?{
        for objectView in objectViews where !objectView.model.destroyed{
            if (carFrame.intersects(objectView.model.frame))
            {
                return objectView
            }
        }
        
        return nil
    }
    
    // collision, return the ObjectViews that has been touched by a shot, todo: what we do with the shot?
    static func hitObjectViews(objectViews : [(model : ObjectViewModel,view : UIImageView)]) -> [(model : ObjectViewModel,view : UIImageView)]{
        
        var hitObjectViews : [(model : ObjectViewModel,view : UIImageView)] = []
        
        for objectView in objectViews where objectView.model.objectViewType != .Shot && !objectView.model.destroyed{
            for shotObjectView in objectViews where shotObjectView.model.objectViewType == .Shot{
                if (shotObjectView.model.frame.intersects(objectView.model.frame)){
                    hitObjectViews.append(objectView)
                }
            }
        }
        
        return hitObjectViews
    
    }
}
