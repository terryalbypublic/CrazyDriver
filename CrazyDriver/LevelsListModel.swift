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
    public let levelsFilenames = ["level1","level2","level3","level4","level5"]
    public let levelsNames = ["Level 1","Level 2","Level 3","Level 4","Level 5"]
    public let nrOfLevels = 5
    public var unlockedLevels : [Bool] = [true,false,false,false,false]
    
    
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
