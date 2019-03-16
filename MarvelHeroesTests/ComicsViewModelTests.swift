//
//  ComicsViewModelTests.swift
//  MarvelHeroesTests
//
//  Created by vit on 3/16/19.
//  Copyright © 2019 ket. All rights reserved.
//

import XCTest
@testable import MarvelHeroes

class ComicsViewModelTests: XCTestCase {
    var comics: ComicsViewModel!
    
    override func setUp() {
        super.setUp()
        comics = ComicsViewModel()
    }

    override func tearDown() {
        super.tearDown()
        comics = nil
    }
    
    func testModelGetComics() {
        let expectation = XCTestExpectation(description: "GetComics tests")
        self.comics.updateComics { error in
            XCTAssertTrue(self.comics.allComicsData.count > 0)
            XCTAssertTrue(error == nil)
            // wait until the expectation is fulfilled, with timeout of 10 seconds
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }


}
