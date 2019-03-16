//
//  CreatorsViewModelTests.swift
//  MarvelHeroesTests
//
//  Created by vit on 3/16/19.
//  Copyright © 2019 ket. All rights reserved.
//

import XCTest
@testable import MarvelHeroes

class CreatorsViewModelTests: XCTestCase {
    var creators: CreatorsViewModel!

    override func setUp() {
        super.setUp()
        creators = CreatorsViewModel()
    }

    override func tearDown() {
        super.tearDown()
        creators = nil
    }
    
    func testModelGetCreators(){
        let expectation = XCTestExpectation(description: "GetCreators test")
        self.creators.updateCreators { error in
            XCTAssertTrue(self.creators.allCreatorsData.count > 0)
            XCTAssertTrue(error == nil)
            // wait until the expectation is fulfilld, with a timeout of 10 seconds
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }

}
