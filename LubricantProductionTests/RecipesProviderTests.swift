//
//  RecipesProviderTests.swift
//  LubricantProductionTests
//
//  Created by Sergey Vasilenko on 18.10.2020.
//  Copyright © 2020 kudrykun. All rights reserved.
//

import XCTest
import FactorioHelper

class RecipesProviderTests: XCTestCase {

    var recipes: [String : Recipe]!

    override func setUpWithError() throws {
        recipes = RecipesProvider.recipes
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }


    func testFillBarrelsExistence() {
        XCTAssertNotNil(recipes["crude-oil-fill-barrel"], "There is not crude-oil-fill-barrel!")
        XCTAssertNotNil(recipes["heavy-oil-fill-barrel"], "There is not heavy-oil-fill-barrel!")
        XCTAssertNotNil(recipes["light-oil-fill-barrel"], "There is not light-oil-fill-barrel!")
        XCTAssertNotNil(recipes["lubricant-fill-barrel"], "There is not lubricant-fill-barrel!")
        XCTAssertNotNil(recipes["petroleum-gas-fill-barrel"], "There is not petroleum-gas-fill-barrel!")
        XCTAssertNotNil(recipes["sulfuric-acid-fill-barrel"], "There is not sulfuric-acid-fill-barrel!")
        XCTAssertNotNil(recipes["water-fill-barrel"], "There is not water-fill-barrel!")
    }
}
