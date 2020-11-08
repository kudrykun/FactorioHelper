//
//  GroupsParserTests.swift
//  LubricantProductionTests
//
//  Created by Sergey Vasilenko on 08.11.2020.
//  Copyright © 2020 kudrykun. All rights reserved.
//

import XCTest
@testable import FactorioHelper

class GroupsParserTests: XCTestCase {

    var groups: [String : Group]!

    override func setUpWithError() throws {
        groups = GroupsParser.getGroups()
    }

    func testFluidsOrder() throws {
        guard let fluidItems = groups["intermediate-products"]?.subgroups.first?.items else { return }
        let fluidNames = fluidItems.map{$0.name}

        let resultArray = ["sulfuric-acid", "petroleum-gas", "heavy-oil", "light-oil", "solid-fuel-from-light-oil", "solid-fuel-from-petroleum-gas", "solid-fuel-from-heavy-oil", "lubricant"]
        XCTAssertEqual(resultArray, fluidNames, "Wrong fluid recipes order!")

    }
}
