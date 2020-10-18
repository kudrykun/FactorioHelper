//
//  FluidItemsGeneratorTests.swift
//  LubricantProductionTests
//
//  Created by Sergey Vasilenko on 18.10.2020.
//  Copyright © 2020 kudrykun. All rights reserved.
//

import XCTest
import FactorioHelper

class FluidItemsGeneratorTests: XCTestCase {

    var fluids: [Fluid]!

    override func setUpWithError() throws {
        fluids = FluidParser.parseFluids()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGeneratingFillBarellRecipes() {
        let items = FluidItemsGenerator.generateFillBarrelItems(from: fluids)
        XCTAssertEqual(items.count, 7, "There is more of less than 7 recipes!")
        for item in items {
            XCTAssertTrue(item.name.contains("fill-barrel"), "Wrong item naming!")
            XCTAssertFalse(item.name.contains("steam"), "Should not fill barrel with steam")
        }
    }

    func testGeneratingEmptyBarellRecipes() {
        let items = FluidItemsGenerator.generateEmptyBarrelItems(from: fluids)
        XCTAssertEqual(items.count, 7, "There is more of less than 7 recipes!")
        for item in items {
            XCTAssertTrue(item.name.contains("empty-barrel"), "Wrong item naming!")
            XCTAssertFalse(item.name.contains("steam"), "Should not empty barrel with steam")
        }
    }
}
