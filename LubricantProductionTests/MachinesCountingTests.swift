//
//  MachinesCountingTests.swift
//  LubricantProductionTests
//
//  Created by Sergey Vasilenko on 20.11.2020.
//  Copyright © 2020 kudrykun. All rights reserved.
//

import XCTest
@testable import FactorioHelper

class MachinesCountingTests: XCTestCase {

    var expressBelt: Recipe!
    var transportBelt: Recipe!
    var modifiedExpressBeltProductionItem: TreeNode<ProductionItem>?

    override func setUpWithError() throws {
        let recipes = RecipesProvider.recipes
        guard let expressBelt = recipes["express-transport-belt"] else { return }
        guard let transportBelt = recipes["transport-belt"] else { return }

        self.expressBelt = expressBelt
        self.transportBelt = transportBelt
    }

    func testMachinesSetCounting_1_Belt_PerSec() {
        guard let transportBeltProductionItem = ProductionCalculator.getProductionItem(for: transportBelt, countPerSecond: 1, nestingLevel: 0) else {
            XCTAssertTrue(false)
            return
        }
        let calculatedMachinesCountSet: [MachinesSet] = ProductionCalculator.getMachinesCountSet(for: transportBeltProductionItem)
        let machinesCountSet = [MachinesSet(type: .StoneFurnace, count: 11), MachinesSet(type: .Machine1, count: 2)]
        XCTAssertEqual(machinesCountSet, calculatedMachinesCountSet)
    }

    func testMachinesSetCounting_3_Belts_PerSec() {
        guard let transportBeltProductionItem = ProductionCalculator.getProductionItem(for: transportBelt, countPerSecond: 3, nestingLevel: 0) else {
            XCTAssertTrue(false)
            return
        }
        let calculatedMachinesCountSet: [MachinesSet] = ProductionCalculator.getMachinesCountSet(for: transportBeltProductionItem)
        let machinesCountSet = [MachinesSet(type: .StoneFurnace, count: 20), MachinesSet(type: .Machine1, count: 4)]
        XCTAssertEqual(machinesCountSet, calculatedMachinesCountSet)
    }

    func testMachinesSetCounting_1_ExpressBelt_PerSec() {
        guard let expressBeltProductionItem = ProductionCalculator.getProductionItem(for: expressBelt, countPerSecond: 1, nestingLevel: 0) else {
            XCTAssertTrue(false)
            return
        }
        let calculatedMachinesCountSet: [MachinesSet] = ProductionCalculator.getMachinesCountSet(for: expressBeltProductionItem)
        let machinesCountSet = [MachinesSet(type: .StoneFurnace, count: 107), MachinesSet(type: .Machine1, count: 18), MachinesSet(type: .Machine2, count: 1), MachinesSet(type: .OilRefinery, count: 4), MachinesSet(type: .ChemicalPlant, count: 2)]
        XCTAssertEqual(machinesCountSet, calculatedMachinesCountSet)
    }

}
