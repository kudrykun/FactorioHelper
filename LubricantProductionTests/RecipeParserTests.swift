//
//  RecipeParserTests.swift
//  LubricantProductionTests
//
//  Created by Sergey Vasilenko on 08.11.2020.
//  Copyright © 2020 kudrykun. All rights reserved.
//

import XCTest
@testable import FactorioHelper

class RecipeParserTests: XCTestCase {

    var parser: RecipeParser!
    var recipes: [String : Recipe]!

    override func setUpWithError() throws {
        parser = RecipeParser()
        recipes = parser.parseRecipes()
    }

    func testOresGeneration() {
        let ironOre = recipes["iron-ore"]
        XCTAssertNotNil(ironOre, "Iron ore recipe should exist!")
        let copperOre = recipes["copper-ore"]
        XCTAssertNotNil(copperOre, "Copper ore recipe should exist!")

        let ironOreRecipe = Recipe(type: "recipe", name: "iron-ore", category: .ore, ingredients: nil, energyRequired: nil, result: nil, normal: nil, expensive: nil, resultCount: nil, icon: "iron-ore", subgroup: nil, order: nil, results: nil)

        let copperOreRecipe = Recipe(type: "recipe", name: "copper-ore", category: .ore, ingredients: nil, energyRequired: nil, result: nil, normal: nil, expensive: nil, resultCount: nil, icon: "copper-ore", subgroup: nil, order: nil, results: nil)

        XCTAssertEqual(ironOre, ironOreRecipe, "Wrong generated recipe!")
        XCTAssertEqual(copperOre, copperOreRecipe, "Wrong generated recipe!")
    }
}
