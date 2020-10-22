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

    override func setUpWithError() throws {
        recipes = RecipesProvider.recipes
        fillBarrelRecipes = []
        fillBarrelRecipes.append(recipes["heavy-oil-fill-barrel"]!)
        fillBarrelRecipes.append(recipes["light-oil-fill-barrel"]!)
        fillBarrelRecipes.append(recipes["lubricant-fill-barrel"]!)
        fillBarrelRecipes.append(recipes["petroleum-gas-fill-barrel"]!)
        fillBarrelRecipes.append(recipes["sulfuric-acid-fill-barrel"]!)
        fillBarrelRecipes.append(recipes["water-fill-barrel"]!)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }


    func testFillBarrelsExistence() {
        XCTAssertNotNil(recipes["crude-oil-fill-barrel"], "There is not crude-oil-fill-barrel!")
        XCTAssertNotNil(recipes["heavy-oil-fill-barrel"], "There is not heavy-oil-fill-barrel!")
        XCTAssertNotNil(recipes["light-oil-fill-barrel"], "There is not light-oil-fill-barrel!")
        XCTAssertNotNil(recipes["lubricant-fill-barrel"], "There is not lubricant-fill-barrel!")
        XCTAssertNotNil(recipes["petroleum-gas-fill-barrel"], "There is not petroleum-gas-fill-barrel!")
        XCTAssertNotNil(recipes["sulfuric-acid-fill-barrel"], "There is not sulfuric-acid-fill-barrel!")
        XCTAssertNotNil(recipes["water-fill-barrel"], "There is not water-fill-barrel!")
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

}
