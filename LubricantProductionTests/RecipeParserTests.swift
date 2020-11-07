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

    func testUraniumsEmptyRecipeExistance() {
        let uranium235 = recipes["uranium-235"]
        let uranium238 = recipes["uranium-238"]

        let uranium235Recipe = Recipe(type: "recipe", name: "uranium-235", category: .centrifuging, ingredients: nil, energyRequired: nil, result: nil, normal: nil, expensive: nil, resultCount: nil, icon: "uranium-235", subgroup: nil, order: nil, results: nil)

        let uranium238Recipe = Recipe(type: "recipe", name: "uranium-238", category: .centrifuging, ingredients: nil, energyRequired: nil, result: nil, normal: nil, expensive: nil, resultCount: nil, icon: "uranium-238", subgroup: nil, order: nil, results: nil)

        XCTAssertNotNil(uranium235, "uranium235 recipe should exist!")
        XCTAssertNotNil(uranium238, "uranium238 recipe should exist!")
        XCTAssertEqual(uranium235, uranium235Recipe, "Wrong generated recipe!")
        XCTAssertEqual(uranium238, uranium238Recipe, "Wrong generated recipe!")
    }
}
