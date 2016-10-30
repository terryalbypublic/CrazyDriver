//
//  CrazyDriverTests.swift
//  CrazyDriverTests
//
//  Created by Alberti Terence on 30/10/16.
//  Copyright © 2016 TA. All rights reserved.
//

import XCTest

class CrazyDriverTests: XCTestCase {
    
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testBestResult() {
        
        let results = ResultsModel.sharedReference
        
        results.addResultForLevelId(levelId: 1, seconds: 25)
        results.addResultForLevelId(levelId: 2, seconds: 26)
        results.addResultForLevelId(levelId: 3, seconds: 27)
        
        
        results.addResultForLevelId(levelId: 1, seconds: 30)
        results.addResultForLevelId(levelId: 2, seconds: 31)
        results.addResultForLevelId(levelId: 3, seconds: 32)
        
        
        results.addResultForLevelId(levelId: 1, seconds: 29)
        results.addResultForLevelId(levelId: 2, seconds: 28)
        results.addResultForLevelId(levelId: 3, seconds: 28)
        
        let one = results.bestResultInSecondsForLevelId(levelId: 1)
        let two = results.bestResultInSecondsForLevelId(levelId: 2)
        let three = results.bestResultInSecondsForLevelId(levelId: 3)
        
        
        XCTAssert(one == 25)
        XCTAssert(two == 26)
        XCTAssert(three == 27)
        
    }
    
    func testResultListOrder(){
        
        let results = ResultsModel.sharedReference
        
        results.addResultForLevelId(levelId: 1, seconds: 25)
        sleep(1)
        results.addResultForLevelId(levelId: 2, seconds: 26)
        sleep(1)
        results.addResultForLevelId(levelId: 3, seconds: 27)
        sleep(1)
        results.addResultForLevelId(levelId: 1, seconds: 30)
        sleep(1)
        results.addResultForLevelId(levelId: 2, seconds: 31)
        sleep(1)
        results.addResultForLevelId(levelId: 3, seconds: 32)
        sleep(1)
        results.addResultForLevelId(levelId: 1, seconds: 29)
        sleep(1)
        results.addResultForLevelId(levelId: 2, seconds: 28)
        sleep(1)
        results.addResultForLevelId(levelId: 3, seconds: 28)
        
        
        let one = results.resultsInSecondsOrderedByCreationDateForLevel(levelId: 1)
        
        let two = results.resultsInSecondsOrderedByCreationDateForLevel(levelId: 2)
        
        let three = results.resultsInSecondsOrderedByCreationDateForLevel(levelId: 3)
        
        XCTAssert(one[0].seconds == 29)
        XCTAssert(two[0].seconds == 28)
        XCTAssert(three[0].seconds == 28)
        
        
        XCTAssert(one[1].seconds == 30)
        XCTAssert(two[1].seconds == 31)
        XCTAssert(three[1].seconds == 32)
        
        
        XCTAssert(one[2].seconds == 25)
        XCTAssert(two[2].seconds == 26)
        XCTAssert(three[2].seconds == 27)
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
