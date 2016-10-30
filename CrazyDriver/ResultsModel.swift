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
    private var results : [(levelId : Int,seconds : Int,dateTime : Date)] = []     // tuple: (levelId,seconds,datetime)
    private let lockQueue = DispatchQueue(label: "com.crazydriver.LockQueue")
    
    
    private override init(){
        super.init()
        loadResultsFromDisk()
    }
    
    public func bestResultInSecondsForLevelId(levelId : Int) -> Int{
        var best = Int.max
        for result in results{
            if(result.levelId == levelId && result.seconds < best){
                best = result.seconds
            }
        }
        return best
    }
    
    public func addResultForLevelId(levelId : Int, seconds : Int) -> Void{
        lockQueue.sync() {
            results.append((levelId, seconds, Date()))
            saveResultsOnDisk()
        }
    }
    
    public func resultsInSecondsOrderedByCreationDateForLevel(levelId : Int) -> Array<(seconds : Int,dateTime : Date)>{
        var resultsOfLevel : [(seconds : Int,dateTime : Date)] = [];
        for result in results{
            if(result.levelId == levelId){
                resultsOfLevel.append((result.seconds,result.dateTime))
            }
        }
        
        resultsOfLevel.sort(by: { $0.dateTime.compare($1.dateTime) == ComparisonResult.orderedDescending })
        
        return resultsOfLevel
    }
    
    private func saveResultsOnDisk(){
        userDefault.set(results, forKey: "results")
        userDefault.synchronize()
    }
    
    private func loadResultsFromDisk(){
        let res = userDefault.object(forKey: "results")
        if(res != nil){
            self.results = res as! [(Int,Int,Date)]
        }
        else{
            self.results = []
        }
    }

}
