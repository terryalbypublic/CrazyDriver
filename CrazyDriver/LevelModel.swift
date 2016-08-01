//
//  LevelsModel.swift
//  CrazyDriver
//
//  Created by Alberti Terence on 31/07/16.
//  Copyright © 2016 TA. All rights reserved.
//

import UIKit


public class LevelModel: NSObject {
    public var levelName = ""
    public var data = Dictionary<Int,String>()
    
    public static func levelModelFromFileName(fileName : String) -> LevelModel{
        
        let levelModel = LevelModel()
        
        var level : NSDictionary? = nil
        // read the level file
        if let filepath = Bundle.main().pathForResource(fileName, ofType: "json") {
            do {
                let contents = try NSString(contentsOfFile: filepath, usedEncoding: nil) as String
                
                // convert String to NSData
                let data: Data = contents.data(using: String.Encoding.utf8)!
                
                // convert NSData to Dictionary
                level = try! JSONSerialization.jsonObject(with: data as Data) as! NSDictionary
                
                // parse and fill the entity
                levelModel.levelName = level?.object(forKey: "LevelName") as! String
                let levelDataDict = level?.object(forKey: "Data") as! Array<NSDictionary>
                
                for d in levelDataDict{
                    levelModel.data.updateValue(d.object(forKey: "Object") as! String , forKey: Int(d.object(forKey: "Tick") as! String)!)
                }
                
            } catch {
                // TODO: handle error
                // contents could not be loaded
            }
        }
        
        return levelModel
    }
}


