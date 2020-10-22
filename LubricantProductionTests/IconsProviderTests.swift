//
//  IconsProviderTests.swift
//  LubricantProductionTests
//
//  Created by Sergey Vasilenko on 22.10.2020.
//  Copyright © 2020 kudrykun. All rights reserved.
//

import XCTest
import FactorioHelper

class IconsProviderTests: XCTestCase {
    var fluids: [Fluid]!

    override func setUpWithError() throws {
        fluids = FluidParser.parseFluids()
    }

    func testFillBarrelsIcons() {
        fluids.forEach { fluid in
            XCTAssertNotNil(IconsProvider.getFillBarrelIcon(for: fluid), "Failed to generate \(fluid.name)-fill-barrel icon!")
        }
    }

    func testEmptyBarrelsIcons() {
        fluids.forEach { fluid in
            XCTAssertNotNil(IconsProvider.getEmptyBarrelIcon(for: fluid), "Failed to generate \(fluid.name)-empty-barrel icon!")
        }
    }

}
