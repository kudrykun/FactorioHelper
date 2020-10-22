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
    var fillBarrelRecipes: [Recipe]!
    var emptyBarrelRecipes: [Recipe]!

    override func setUpWithError() throws {
        recipes = RecipesProvider.recipes
        fillBarrelRecipes = []
        fillBarrelRecipes.append(recipes["heavy-oil-fill-barrel"]!)
        fillBarrelRecipes.append(recipes["light-oil-fill-barrel"]!)
        fillBarrelRecipes.append(recipes["lubricant-fill-barrel"]!)
        fillBarrelRecipes.append(recipes["petroleum-gas-fill-barrel"]!)
        fillBarrelRecipes.append(recipes["sulfuric-acid-fill-barrel"]!)
        fillBarrelRecipes.append(recipes["water-fill-barrel"]!)

        emptyBarrelRecipes = []
        emptyBarrelRecipes.append(recipes["heavy-oil-empty-barrel"]!)
        emptyBarrelRecipes.append(recipes["light-oil-empty-barrel"]!)
        emptyBarrelRecipes.append(recipes["lubricant-empty-barrel"]!)
        emptyBarrelRecipes.append(recipes["petroleum-gas-empty-barrel"]!)
        emptyBarrelRecipes.append(recipes["sulfuric-acid-empty-barrel"]!)
        emptyBarrelRecipes.append(recipes["water-empty-barrel"]!)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFillBarrelsCorrectness() {
        for recipe in fillBarrelRecipes {
            XCTAssertEqual(recipe.baseProductionTime, 0.2, "Wrong fill barrel time!")
            XCTAssertEqual(recipe.subgroup, "fill-barrel")

            if let liquidStringRange = recipe.name.range(of: "-fill-barrel") {
                var liquidString = recipe.name
                liquidString.removeSubrange(liquidStringRange)
                let ingredients = [Ingredient(name: "empty-barrel", amount: 1), Ingredient(name: liquidString, amount: 50)]

                XCTAssertEqual(recipe.baseIngredients, ingredients, "Wrong ingredients!")
                XCTAssertEqual(recipe.result, recipe.name, "Wrong result!")
                XCTAssertEqual(recipe.baseProductionResultCount, 1, "Wrong result count!")
            } else {
                XCTAssert(true, "Wrong recipe naming!")
            }
        }
    }

    func testEmptyBarrelsCorrectness() {
        for recipe in emptyBarrelRecipes {
            XCTAssertEqual(recipe.baseProductionTime, 0.2, "Wrong empty barrel time!")
            XCTAssertEqual(recipe.subgroup, "empty-barrel")

            if let liquidStringRange = recipe.name.range(of: "-empty-barrel") {
                var liquidString = recipe.name
                liquidString.removeSubrange(liquidStringRange)
                let ingredients = [Ingredient(name: "\(liquidString)-fill-barrel", amount: 1)]
                let results = [Result(name: "empty-barrel", probability: nil, amount: 1, type: nil, fluidbox_index: nil), Result(name: liquidString, probability: nil, amount: 50, type: nil, fluidbox_index: nil)]

                XCTAssertEqual(recipe.baseIngredients, ingredients, "Wrong ingredients!")
                XCTAssertEqual(recipe.results, results, "Wrong results!")
            } else {
                XCTAssert(true, "Wrong recipe naming!")
            }
        }
    }

}
