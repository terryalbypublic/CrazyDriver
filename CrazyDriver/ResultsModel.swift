//
//  ResultsModel.swift
//  CrazyDriver
//
//  Created by Alberti Terence on 29/10/16.
//  Copyright © 2016 TA. All rights reserved.
//

import UIKit


public class ResultsModel: NSObject {
    
    public static let sharedReference = ResultsModel()
    private let userDefault = UserDefaults.standard
    private var results : [(levelId : Int,milliseconds : Int,dateTime : Date)] = []     // tuple: (levelId,seconds,datetime)
    private let lockQueue = DispatchQueue(label: "com.crazydriver.LockQueue")
    
    
    private override init(){
        super.init()
        loadResultsFromDisk()
    }
    
    public func bestResultInMillisecondsForLevelId(levelId : Int) -> Int{
        var best = Int.max
        for result in results{
            if(result.levelId == levelId && result.milliseconds < best){
                best = result.milliseconds
            }
        }
        return best
    }
    
    public func addResultForLevelId(levelId : Int, milliseconds : Int) -> Void{
        lockQueue.sync() {
            results.append((levelId, milliseconds, Date()))
            DispatchQueue.global(qos: .background).async {
                self.saveResultsOnDisk()
            }
        }
    }
    
    public func resultsInSecondsOrderedByCreationDateForLevel(levelId : Int) -> Array<(seconds : Int,dateTime : Date)>{
        var resultsOfLevel : [(seconds : Int,dateTime : Date)] = [];
        for result in results{
            if(result.levelId == levelId){
                resultsOfLevel.append((result.milliseconds,result.dateTime))
            }
        }
        
        resultsOfLevel.sort(by: { $0.dateTime.compare($1.dateTime) == ComparisonResult.orderedDescending })
        
        return resultsOfLevel
    }
    
    public func resultsInSecondsOrderedByCreationDate() -> Array<(levelId : Int, milliseconds : Int , dateTime : Date)>{
        
        return results.sorted(by: { $0.dateTime.compare($1.dateTime) == ComparisonResult.orderedDescending })
    }
    
    private func saveResultsOnDisk(){
        userDefault.set(ResultsModel.resultsToData(results: results), forKey: "results")
        userDefault.synchronize()
    }
    
    private static func resultsToData(results : [(levelId : Int,milliseconds : Int,dateTime : Date)]) -> Data{
        
        // array of dictionary
        var array = [Dictionary<String,Any>]()
        
        for result in results{
            var dict = Dictionary<String,Any>()
            dict.updateValue(result.levelId, forKey: "LevelId")
            dict.updateValue(result.milliseconds, forKey: "Milliseconds")
            dict.updateValue(result.dateTime, forKey: "DateTime")
            array.append(dict)
        }
        
        return NSKeyedArchiver.archivedData(withRootObject: array)
    }
    
    private static func resultsFromData(data : Data) -> [(levelId : Int,milliseconds : Int,dateTime : Date)]{
        
        var results : [(levelId : Int,milliseconds : Int,dateTime : Date)] = []
        
        let array = NSKeyedUnarchiver.unarchiveObject(with: data) as! [Dictionary<String,Any>]
        
        for dict in array{
            let result : (levelId : Int,milliseconds : Int,dateTime : Date)
            result.milliseconds = dict["Milliseconds"] as! Int
            result.levelId = dict["LevelId"] as! Int
            result.dateTime = dict["DateTime"] as! Date
            
            results.append(result)
        }
        
        return results
    }
    
    private func loadResultsFromDisk(){
        let data = userDefault.object(forKey: "results")
        if(data != nil){
            self.results = ResultsModel.resultsFromData(data: data as! Data)
        }
        else{
            self.results = []
        }
    }
}
