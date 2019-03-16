//
//  RouterTests.swift
//  MarvelHeroesTests
//
//  Created by vit on 3/13/19.
//  Copyright © 2019 ket. All rights reserved.
//

import XCTest
@testable import MarvelHeroes

class RouterTests: XCTestCase {
    
    func testRouterGetHeroes() {
        XCTAssertNoThrow(Router.asURLRequest(Router.getHeroes(withLimit: 20, withOffset: 0)))
    }
    
}
