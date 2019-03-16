//
//  HeroesViewModelTests.swift
//
//  Created by vit on 3/13/19.
//  Copyright © 2019 ket. All rights reserved.
//

import XCTest
@testable import MarvelHeroes

class HeroesViewModelTests: XCTestCase {
    var heroes: HeroesViewModel!
    
    override func setUp() {
        super.setUp()
        heroes = HeroesViewModel()
    }
    
    override func tearDown() {
        super.tearDown()
        heroes = nil
    }
    
    func testModelGetHeroes() {
        let expectation = XCTestExpectation(description: "GetHeroes tests")
        self.heroes.updateHeroes { error in
            XCTAssertTrue(self.heroes.allHeroesData.count > 0)
            XCTAssertTrue(error == nil)
            // Wait until the expectation is fulfilled, with a timeout of 10 seconds.
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
}
