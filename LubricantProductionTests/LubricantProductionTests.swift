//
//  LubricantProductionTests.swift
//  LubricantProductionTests
//
//  Created by Sergey Vasilenko on 18.10.2020.
//  Copyright © 2020 kudrykun. All rights reserved.
//

import XCTest
import FactorioHelper

class LubricantProductionTests: XCTestCase {

    var lubricantRecipe: Recipe!
    var heavyOilRecipe: Recipe!
    var waterRecipe: Recipe!
    var crudeOilRecipe: Recipe!

    override func setUpWithError() throws {
        let recipes = RecipesProvider.recipes
        guard let lubricantRecipe = recipes["lubricant"] else { return  }
        guard let heavyOilRecipe = recipes["heavy-oil"] else { return  }
        guard let waterRecipe = recipes["water"] else { return  }
        guard let crudeOilRecipe = recipes["crude-oil"] else { return  }

        self.lubricantRecipe = lubricantRecipe
        self.heavyOilRecipe = heavyOilRecipe
        self.waterRecipe = waterRecipe
        self.crudeOilRecipe = crudeOilRecipe
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test1perSecProduction() {
        let lubricantProductionItem = TreeNode<ProductionItem>(ProductionItem(name: "lubricant", countPerSecond: 1, machinesNeeded: 1, machineType: .ChemicalPlant, recipe: lubricantRecipe))

        let heavyOilProductionItem = TreeNode<ProductionItem>(ProductionItem(name: "heavy-oil", countPerSecond: 10, machinesNeeded: 2, machineType: .OilRefinery, recipe: heavyOilRecipe))

        let waterProductionItem = TreeNode<ProductionItem>(ProductionItem(name: "water", countPerSecond: 100, machinesNeeded: nil, machineType: ProductionCalculator.getMachineType(for: waterRecipe), recipe: waterRecipe))

        let crudeOilProductionItem = TreeNode<ProductionItem>(ProductionItem(name: "crude-oil", countPerSecond: 200, machinesNeeded: nil, machineType: ProductionCalculator.getMachineType(for: crudeOilRecipe), recipe: crudeOilRecipe))


        heavyOilProductionItem.addChild(waterProductionItem)
        heavyOilProductionItem.addChild(crudeOilProductionItem)
        lubricantProductionItem.addChild(heavyOilProductionItem)


        let resultProductionItem = ProductionCalculator.getProductionItem(for: lubricantRecipe, countPerSecond: 1)

        XCTAssertEqual(lubricantProductionItem, resultProductionItem, "Wrong lubricant 1 per second productionItem!")
    }

    func test5perSecProduction() {
        let lubricantProductionItem = TreeNode<ProductionItem>(ProductionItem(name: "lubricant", countPerSecond: 5, machinesNeeded: 1, machineType: .ChemicalPlant, recipe: lubricantRecipe))

        let heavyOilProductionItem = TreeNode<ProductionItem>(ProductionItem(name: "heavy-oil", countPerSecond: 10, machinesNeeded: 2, machineType: .OilRefinery, recipe: heavyOilRecipe))

        let waterProductionItem = TreeNode<ProductionItem>(ProductionItem(name: "water", countPerSecond: 100, machinesNeeded: nil, machineType: ProductionCalculator.getMachineType(for: waterRecipe), recipe: waterRecipe))

        let crudeOilProductionItem = TreeNode<ProductionItem>(ProductionItem(name: "crude-oil", countPerSecond: 200, machinesNeeded: nil, machineType: ProductionCalculator.getMachineType(for: crudeOilRecipe), recipe: crudeOilRecipe))


        heavyOilProductionItem.addChild(waterProductionItem)
        heavyOilProductionItem.addChild(crudeOilProductionItem)
        lubricantProductionItem.addChild(heavyOilProductionItem)


        let resultProductionItem = ProductionCalculator.getProductionItem(for: lubricantRecipe, countPerSecond: 5)

        XCTAssertEqual(lubricantProductionItem, resultProductionItem, "Wrong lubricant 1 per second productionItem!")
    }

    func test10perSecProduction() {

        let lubricantProductionItem = TreeNode<ProductionItem>(ProductionItem(name: "lubricant", countPerSecond: 10, machinesNeeded: 1, machineType: .ChemicalPlant, recipe: lubricantRecipe))

        let heavyOilProductionItem = TreeNode<ProductionItem>(ProductionItem(name: "heavy-oil", countPerSecond: 10, machinesNeeded: 2, machineType: .OilRefinery, recipe: heavyOilRecipe))

        let waterProductionItem = TreeNode<ProductionItem>(ProductionItem(name: "water", countPerSecond: 100, machinesNeeded: nil, machineType: ProductionCalculator.getMachineType(for: waterRecipe), recipe: waterRecipe))

        let crudeOilProductionItem = TreeNode<ProductionItem>(ProductionItem(name: "crude-oil", countPerSecond: 200, machinesNeeded: nil, machineType: ProductionCalculator.getMachineType(for: crudeOilRecipe), recipe: crudeOilRecipe))


        heavyOilProductionItem.addChild(waterProductionItem)
        heavyOilProductionItem.addChild(crudeOilProductionItem)
        lubricantProductionItem.addChild(heavyOilProductionItem)


        let resultProductionItem = ProductionCalculator.getProductionItem(for: lubricantRecipe, countPerSecond: 10)

        XCTAssertEqual(lubricantProductionItem, resultProductionItem, "Wrong lubricant 10 per second productionItem!")
    }

    func test20perSecProduction() {
        let lubricantProductionItem = TreeNode<ProductionItem>(ProductionItem(name: "lubricant", countPerSecond: 20, machinesNeeded: 2, machineType: .ChemicalPlant, recipe: lubricantRecipe))

        let heavyOilProductionItem = TreeNode<ProductionItem>(ProductionItem(name: "heavy-oil", countPerSecond: 20, machinesNeeded: 4, machineType: .OilRefinery, recipe: heavyOilRecipe))

        let waterProductionItem = TreeNode<ProductionItem>(ProductionItem(name: "water", countPerSecond: 200, machinesNeeded: nil, machineType: ProductionCalculator.getMachineType(for: waterRecipe), recipe: waterRecipe))

        let crudeOilProductionItem = TreeNode<ProductionItem>(ProductionItem(name: "crude-oil", countPerSecond: 400, machinesNeeded: nil, machineType: ProductionCalculator.getMachineType(for: crudeOilRecipe), recipe: crudeOilRecipe))


        heavyOilProductionItem.addChild(waterProductionItem)
        heavyOilProductionItem.addChild(crudeOilProductionItem)
        lubricantProductionItem.addChild(heavyOilProductionItem)


        let resultProductionItem = ProductionCalculator.getProductionItem(for: lubricantRecipe, countPerSecond: 20)

        XCTAssertEqual(lubricantProductionItem, resultProductionItem, "Wrong lubricant 20 per second productionItem!")
    }

}
