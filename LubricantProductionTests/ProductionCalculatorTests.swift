//
//  ProductionCalculatorTests.swift
//  LubricantProductionTests
//
//  Created by Sergey Vasilenko on 01.11.2020.
//  Copyright © 2020 kudrykun. All rights reserved.
//

import XCTest
import FactorioHelper

class ProductionCalculatorTests: XCTestCase {

    var lubricantRecipe: Recipe!
    var heavyOilRecipe: Recipe!
    var waterRecipe: Recipe!
    var crudeOilRecipe: Recipe!
    var spidertroneRecipe: Recipe!
    var expressBelt: Recipe!

    override func setUpWithError() throws {
        let recipes = RecipesProvider.recipes
        guard let lubricantRecipe = recipes["lubricant"] else { return  }
        guard let heavyOilRecipe = recipes["heavy-oil"] else { return  }
        guard let waterRecipe = recipes["water"] else { return  }
        guard let crudeOilRecipe = recipes["crude-oil"] else { return  }
        guard let spidertroneRecipe = recipes["spidertron"] else { return  }
        guard let expressBelt = recipes["express-transport-belt"] else { return  }

        self.lubricantRecipe = lubricantRecipe
        self.heavyOilRecipe = heavyOilRecipe
        self.waterRecipe = waterRecipe
        self.crudeOilRecipe = crudeOilRecipe
        self.spidertroneRecipe = spidertroneRecipe
        self.expressBelt = expressBelt
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLube1perSecProduction() {
        let lubricantProductionItem = TreeNode<ProductionItem>(ProductionItem(name: "lubricant", countPerSecond: 1, machinesNeeded: 1, machineType: .ChemicalPlant, recipe: lubricantRecipe, nestingLevel: 0))

        let heavyOilProductionItem = TreeNode<ProductionItem>(ProductionItem(name: "heavy-oil", countPerSecond: 10, machinesNeeded: 2, machineType: .OilRefinery, recipe: heavyOilRecipe, nestingLevel: 1))

        let waterProductionItem = TreeNode<ProductionItem>(ProductionItem(name: "water", countPerSecond: 100, machinesNeeded: nil, machineType: nil, recipe: waterRecipe, nestingLevel: 2))

        let crudeOilProductionItem = TreeNode<ProductionItem>(ProductionItem(name: "crude-oil", countPerSecond: 200, machinesNeeded: nil, machineType: nil, recipe: crudeOilRecipe, nestingLevel: 2))


        heavyOilProductionItem.addChild(waterProductionItem)
        heavyOilProductionItem.addChild(crudeOilProductionItem)
        lubricantProductionItem.addChild(heavyOilProductionItem)


        let resultProductionItem = ProductionCalculator.getProductionItem(for: lubricantRecipe, countPerSecond: 1, nestingLevel: 0)

        XCTAssertEqual(lubricantProductionItem, resultProductionItem, "Wrong lubricant 1 per second productionItem!")
    }

    func testLube5perSecProduction() {
        let lubricantProductionItem = TreeNode<ProductionItem>(ProductionItem(name: "lubricant", countPerSecond: 5, machinesNeeded: 1, machineType: .ChemicalPlant, recipe: lubricantRecipe, nestingLevel: 0))

        let heavyOilProductionItem = TreeNode<ProductionItem>(ProductionItem(name: "heavy-oil", countPerSecond: 10, machinesNeeded: 2, machineType: .OilRefinery, recipe: heavyOilRecipe, nestingLevel: 1))

        let waterProductionItem = TreeNode<ProductionItem>(ProductionItem(name: "water", countPerSecond: 100, machinesNeeded: nil, machineType: nil, recipe: waterRecipe, nestingLevel: 2))

        let crudeOilProductionItem = TreeNode<ProductionItem>(ProductionItem(name: "crude-oil", countPerSecond: 200, machinesNeeded: nil, machineType: nil, recipe: crudeOilRecipe, nestingLevel: 2))


        heavyOilProductionItem.addChild(waterProductionItem)
        heavyOilProductionItem.addChild(crudeOilProductionItem)
        lubricantProductionItem.addChild(heavyOilProductionItem)


        let resultProductionItem = ProductionCalculator.getProductionItem(for: lubricantRecipe, countPerSecond: 5, nestingLevel: 0)

        XCTAssertEqual(lubricantProductionItem, resultProductionItem, "Wrong lubricant 1 per second productionItem!")
    }

    func testLube10perSecProduction() {

        let lubricantProductionItem = TreeNode<ProductionItem>(ProductionItem(name: "lubricant", countPerSecond: 10, machinesNeeded: 1, machineType: .ChemicalPlant, recipe: lubricantRecipe, nestingLevel: 0))

        let heavyOilProductionItem = TreeNode<ProductionItem>(ProductionItem(name: "heavy-oil", countPerSecond: 10, machinesNeeded: 2, machineType: .OilRefinery, recipe: heavyOilRecipe, nestingLevel: 1))

        let waterProductionItem = TreeNode<ProductionItem>(ProductionItem(name: "water", countPerSecond: 100, machinesNeeded: nil, machineType: nil, recipe: waterRecipe, nestingLevel: 2))

        let crudeOilProductionItem = TreeNode<ProductionItem>(ProductionItem(name: "crude-oil", countPerSecond: 200, machinesNeeded: nil, machineType: nil, recipe: crudeOilRecipe, nestingLevel: 2))


        heavyOilProductionItem.addChild(waterProductionItem)
        heavyOilProductionItem.addChild(crudeOilProductionItem)
        lubricantProductionItem.addChild(heavyOilProductionItem)


        let resultProductionItem = ProductionCalculator.getProductionItem(for: lubricantRecipe, countPerSecond: 10, nestingLevel: 0)

        XCTAssertEqual(lubricantProductionItem, resultProductionItem, "Wrong lubricant 10 per second productionItem!")
    }

    func testLube20perSecProduction() {
        let lubricantProductionItem = TreeNode<ProductionItem>(ProductionItem(name: "lubricant", countPerSecond: 20, machinesNeeded: 2, machineType: .ChemicalPlant, recipe: lubricantRecipe, nestingLevel: 0))

        let heavyOilProductionItem = TreeNode<ProductionItem>(ProductionItem(name: "heavy-oil", countPerSecond: 20, machinesNeeded: 4, machineType: .OilRefinery, recipe: heavyOilRecipe, nestingLevel: 1))

        let waterProductionItem = TreeNode<ProductionItem>(ProductionItem(name: "water", countPerSecond: 200, machinesNeeded: nil, machineType: nil, recipe: waterRecipe, nestingLevel: 2))

        let crudeOilProductionItem = TreeNode<ProductionItem>(ProductionItem(name: "crude-oil", countPerSecond: 400, machinesNeeded: nil, machineType: nil, recipe: crudeOilRecipe, nestingLevel: 2))


        heavyOilProductionItem.addChild(waterProductionItem)
        heavyOilProductionItem.addChild(crudeOilProductionItem)
        lubricantProductionItem.addChild(heavyOilProductionItem)


        let resultProductionItem = ProductionCalculator.getProductionItem(for: lubricantRecipe, countPerSecond: 20, nestingLevel: 0)

        XCTAssertEqual(lubricantProductionItem, resultProductionItem, "Wrong lubricant 20 per second productionItem!")
    }

    func testLubeFlattening() {
        let lubricantProductionItem = TreeNode<ProductionItem>(ProductionItem(name: "lubricant", countPerSecond: 1, machinesNeeded: 1, machineType: .ChemicalPlant, recipe: lubricantRecipe, nestingLevel: 0))

        let heavyOilProductionItem = TreeNode<ProductionItem>(ProductionItem(name: "heavy-oil", countPerSecond: 10, machinesNeeded: 2, machineType: .OilRefinery, recipe: heavyOilRecipe, nestingLevel: 1))

        let waterProductionItem = TreeNode<ProductionItem>(ProductionItem(name: "water", countPerSecond: 100, machinesNeeded: nil, machineType: ProductionCalculator.getMachineType(for: waterRecipe), recipe: waterRecipe, nestingLevel: 2))

        let crudeOilProductionItem = TreeNode<ProductionItem>(ProductionItem(name: "crude-oil", countPerSecond: 200, machinesNeeded: nil, machineType: ProductionCalculator.getMachineType(for: crudeOilRecipe), recipe: crudeOilRecipe, nestingLevel: 2))


        let testFlattenedArray = [lubricantProductionItem, heavyOilProductionItem, waterProductionItem, crudeOilProductionItem]

        guard let resultProductionItem = ProductionCalculator.getProductionItem(for: lubricantRecipe, countPerSecond: 1, nestingLevel: 0) else {
            XCTAssertTrue(false, "Lubricant production item not created!")
            return
        }
        let resultFlattenedArray = resultProductionItem.flattened()

        for i in 0..<testFlattenedArray.count {
            XCTAssertEqual(testFlattenedArray[i].value.name, resultFlattenedArray[i].value.name, "Wrong lubricant production item flattening!")
        }
    }

    func testSpiderTronePossibleMachines() {
        let possibleMachineTypes = ProductionCalculator.getPossibleMachineTypes(for: spidertroneRecipe)
        XCTAssertEqual(possibleMachineTypes, [MachineType.Machine1, MachineType.Machine2, MachineType.Machine3])
    }

    func testInitialMachineForExpressBeltIsNotMachine1() {
        guard let item = ProductionCalculator.getProductionItem(for: expressBelt, countPerSecond: 1, nestingLevel: 0) else {
            XCTAssertTrue(false, "Express belt production item not created!")
            return
        }
        XCTAssertNotEqual(item.value.machineType, MachineType.Machine1, "Wrong initial machineType for express-belt!")
    }

    func testWaterPossibleMachinesIsEmpty() {
        let possibleMachineTypes = ProductionCalculator.getPossibleMachineTypes(for: waterRecipe)
        XCTAssertEqual(possibleMachineTypes, [], "Possible machines array for water is not empty!")
    }
}
