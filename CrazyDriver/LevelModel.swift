//
//  LevelsModel.swift
//  CrazyDriver
//
//  Created by Alberti Terence on 31/07/16.
//  Copyright © 2016 TA. All rights reserved.
//

import UIKit

public class LevelData : NSObject{
    
    public var tick = 0
    public var object = ""
    
}


public class LevelModel: NSObject {
    public var levelName = ""
    public var data = Array<LevelData>()
    
    public static func levelModelFromFileName(fileName : String) -> LevelModel{
        
        let levelModel = LevelModel()
        
        var level : NSDictionary? = nil
        
        if let filepath = Bundle.main().pathForResource(fileName, ofType: "json") {
            do {
                let contents = try NSString(contentsOfFile: filepath, usedEncoding: nil) as String
                
                // convert String to NSData
                let data: Data = contents.data(using: String.Encoding.utf8)!
                
                // convert NSData to 'AnyObject'
                level = try! JSONSerialization.jsonObject(with: data as Data) as! NSDictionary
                
                // parse
                levelModel.levelName = level?.object(forKey: "LevelName") as! String
                let levelDataDict = level?.object(forKey: "Data") as! Array<NSDictionary>
                let levelData = LevelData()
                for d in levelDataDict{
                    levelData.tick = Int(d.object(forKey: "Tick") as! String)!
                    levelData.object = d.object(forKey: "Object") as! String
                }
                levelModel.data.append(levelData)
                
            } catch {
                // contents could not be loaded
            }
        }
        
        return levelModel
    }
}


