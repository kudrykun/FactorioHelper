//
//  ItemTests.swift
//  LubricantProductionTests
//
//  Created by Sergey Vasilenko on 18.10.2020.
//  Copyright © 2020 kudrykun. All rights reserved.
//

import XCTest
import FactorioHelper

class ItemTests: XCTestCase {
    var fillBarrelItems: [Item]!
    var emptyBarrelItems: [Item]!

    override func setUpWithError() throws {
        fillBarrelItems = FluidItemsGenerator.generateFillBarrelItems(from: FluidParser.parseFluids())
        emptyBarrelItems = FluidItemsGenerator.generateEmptyBarrelItems(from: FluidParser.parseFluids())
    }

    func testIconsFillBarrel() {
        for item in fillBarrelItems {
            XCTAssertNotNil(item.croppedIcon, "There is no image for \(item)")
        }
    }

    func testIconsEmptyBarrel() {
        for item in emptyBarrelItems {
            XCTAssertNotNil(item.croppedIcon, "There is no image for \(item)")
        }
    }
}
