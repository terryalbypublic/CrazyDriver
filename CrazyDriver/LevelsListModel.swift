//
//  LevelsList.swift
//  CrazyDriver
//
//  Created by Alberti Terence on 01/02/17.
//  Copyright © 2017 TA. All rights reserved.
//

import UIKit

public class LevelsListModel: NSObject {

    
    public static let sharedReference = LevelsListModel()
    private let userDefault = UserDefaults.standard
    public let levelsFilenames = ["level1","level2"]
    public let levelsNames = ["Level 1","Level 2"]
    public let nrOfLevels = 2
    public var unlockedLevels : [Bool] = [true,false]
    
    
    override init(){
        super.init()
        loadUnlockedLevels()
    }
    
    public func saveUnlockedLevel(id:Int){
        unlockedLevels[id] = true   // save value in memory
        userDefault.set(unlockedLevels, forKey: "unlockedLevels")
        userDefault.synchronize()   // save value on disk
    }
    
    public func loadUnlockedLevels(){
        // read value from disk
        let unlockedLevels = userDefault.object(forKey: "unlockedLevels")
        if(unlockedLevels != nil){
            self.unlockedLevels = unlockedLevels as! [Bool]
        }
    }
    
    
    
}
