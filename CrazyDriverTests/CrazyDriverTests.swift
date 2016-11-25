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
        
        results.addResultForLevelId(levelId: 1, milliseconds: 25)
        sleep(1)
        results.addResultForLevelId(levelId: 2, milliseconds: 26)
        sleep(1)
        results.addResultForLevelId(levelId: 3, milliseconds: 27)
        sleep(1)
        results.addResultForLevelId(levelId: 1, milliseconds: 30)
        sleep(1)
        results.addResultForLevelId(levelId: 2, milliseconds: 31)
        sleep(1)
        results.addResultForLevelId(levelId: 3, milliseconds: 32)
        sleep(1)
        results.addResultForLevelId(levelId: 1, milliseconds: 29)
        sleep(1)
        results.addResultForLevelId(levelId: 2, milliseconds: 28)
        sleep(1)
        results.addResultForLevelId(levelId: 3, milliseconds: 28)
        
        let one = results.resultsInSecondsOrderedByCreationDate()
        
        XCTAssert(one[0].milliseconds == 28)
        
        XCTAssert(one[1].milliseconds == 28)
        
        XCTAssert(one[2].milliseconds == 29)
        
        XCTAssert(one[3].milliseconds == 32)
        
        XCTAssert(one[4].milliseconds == 31)
        
        XCTAssert(one[5].milliseconds == 30)
        
        XCTAssert(one[6].milliseconds == 27)
        
        XCTAssert(one[7].milliseconds == 26)
        
        XCTAssert(one[8].milliseconds == 25)
        
    }
    
    func testBestResultForLevelId() {
        
        let results = ResultsModel.sharedReference
        
        results.addResultForLevelId(levelId: 1, milliseconds: 25)
        results.addResultForLevelId(levelId: 2, milliseconds: 26)
        results.addResultForLevelId(levelId: 3, milliseconds: 27)
        
        
        results.addResultForLevelId(levelId: 1, milliseconds: 30)
        results.addResultForLevelId(levelId: 2, milliseconds: 31)
        results.addResultForLevelId(levelId: 3, milliseconds: 32)
        
        
        results.addResultForLevelId(levelId: 1, milliseconds: 29)
        results.addResultForLevelId(levelId: 2, milliseconds: 28)
        results.addResultForLevelId(levelId: 3, milliseconds: 28)
        
        let one = results.bestResultInMillisecondsForLevelId(levelId: 1)
        let two = results.bestResultInMillisecondsForLevelId(levelId: 2)
        let three = results.bestResultInMillisecondsForLevelId(levelId: 3)
        
        
        XCTAssert(one == 25)
        XCTAssert(two == 26)
        XCTAssert(three == 27)
        
    }
    
    func testResultListOrderForLevelId(){
        
        let results = ResultsModel.sharedReference
        
        results.addResultForLevelId(levelId: 1, milliseconds: 25)
        sleep(1)
        results.addResultForLevelId(levelId: 2, milliseconds: 26)
        sleep(1)
        results.addResultForLevelId(levelId: 3, milliseconds: 27)
        sleep(1)
        results.addResultForLevelId(levelId: 1, milliseconds: 30)
        sleep(1)
        results.addResultForLevelId(levelId: 2, milliseconds: 31)
        sleep(1)
        results.addResultForLevelId(levelId: 3, milliseconds: 32)
        sleep(1)
        results.addResultForLevelId(levelId: 1, milliseconds: 29)
        sleep(1)
        results.addResultForLevelId(levelId: 2, milliseconds: 28)
        sleep(1)
        results.addResultForLevelId(levelId: 3, milliseconds: 28)
        
        
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
