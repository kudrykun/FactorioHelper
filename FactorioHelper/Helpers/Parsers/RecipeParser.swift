//
//  RecipeParser.swift
//  FactorioHelper
//
//  Created by Sergey Vasilenko on 03.09.2020.
//  Copyright © 2020 kudrykun. All rights reserved.
//

import Foundation

class RecipeParser {

    private enum RecipeField: String {
        case type = "type"
        case name = "name"
        case category = "category"
        case ingredients = "ingredients"
        case energyRequired = "energy_required"
        case result = "result"
        case normal = "normal"
        case expensive = "expensive"
        case resultCount = "result_count"
        case icon = "icon"
        case subgroup = "subgroup"
        case order = "order"
        case results = "results"
    }

    private enum IngredientField: String {
        case name = "name"
        case amount = "amount"
        case type = "type"
    }

    private enum DifficultyRecipeField: String {
        case enabled = "enabled"
        case energyRequired = "energy_required"
        case ingredients = "ingredients"
        case result = "result"
    }

    private enum MachineTineField: String {
        case primary = "primary"
        case secondary = "secondary"
        case tertiary = "tertiary"
        case quaternary = "quaternary"
    }

    private enum ResultField: String {
        case name = "name"
        case probability = "probability"
        case amount = "amount"
        case type = "type"
        case fluidboxIndex = "fluidbox_index"
    }

    let filenames = ["ammo", "capsule", "circuit-network", "demo-furnace-recipe", "demo-recipe", "demo-turret", "equipment", "fluid-recipe", "inserter", "module", "recipe", "turret"]

    func parseRecipes() -> [String : Recipe] {
        var recipes: [String : Recipe] = [:]

        for filename in filenames {
            let fullFilename = filename + "JSONED"

            guard let url = Bundle.main.url(forResource: fullFilename, withExtension: "json") else { return recipes }

            do {
                let data = try Data(contentsOf: url)
                guard let recipesArray = try JSONSerialization.jsonObject(with: data, options: []) as? [Any] else { return recipes }
                for recipeJSON in recipesArray {
                    guard let recipeJSON = recipeJSON as? [String: Any] else { continue }
                    guard let recipe = parseRecipe(from: recipeJSON) else { continue }
                    recipes[recipe.name] = recipe
                }
            } catch {
                print(error)
            }
        }


        let fluidRecipes = generateBaseFluidRecipes()
        fluidRecipes.forEach { recipe in
            recipes[recipe.name] = recipe
        }

        let oreRecipes = generateBaseOreRecipes()
        oreRecipes.forEach { recipe in
            recipes[recipe.name] = recipe
        }

//        let barrelFillRecipes = generateFillBarrelRecipes()
//        barrelFillRecipes.forEach { recipe in
//            recipes[recipe.name] = recipe
//        }
//
//        let barrelEmptyRecipes = generateEmptyBarrelRecipes()
//        barrelEmptyRecipes.forEach { recipe in
//            recipes[recipe.name] = recipe
//        }

        if let oilProcessingRecipe = recipes["advanced-oil-processing"] {
            let oilProcessingRecipes = generateOilProcessingLiquidRecipes(oilProcessingRecipe)
            oilProcessingRecipes.forEach { recipe in
                recipes[recipe.name] = recipe
            }
        }

        return recipes
    }

    func generateOilProcessingLiquidRecipes(_ oilProcessingRecipe: Recipe) -> [Recipe] {
        var recipes: [Recipe] = []
        guard let results = oilProcessingRecipe.results else { return [] }

        for result in results {
            recipes.append(Recipe(type: "recipe", name: result.name ?? "", category: .oilProcessing, ingredients: oilProcessingRecipe.baseIngredients, energyRequired: oilProcessingRecipe.baseProductionTime, result: nil, normal: nil, expensive: nil, resultCount: result.amount, icon: result.name, subgroup: "fluid-recipes", order: nil, results: nil))
        }

        /*
         struct Result: Codable {
             var name: String?
             var probability: Double?
             var amount: Int?
             var type: String?
             var fluidbox_index: Int?
         }
         */

        return recipes
    }

    func generateBaseFluidRecipes() -> [Recipe] {
        var recipes: [Recipe] = []
        let water = Recipe(type: "recipe", name: "water", category: .fluid, ingredients: nil, energyRequired: nil, result: nil, normal: nil, expensive: nil, resultCount: nil, icon: "water", subgroup: nil, order: nil, results: nil)
        recipes.append(water)

        let crudeOil = Recipe(type: "recipe", name: "crude-oil", category: .fluid, ingredients: nil, energyRequired: nil, result: nil, normal: nil, expensive: nil, resultCount: nil, icon: "crude-oil", subgroup: nil, order: nil, results: nil)
        recipes.append(crudeOil)

        return recipes
    }

    func generateBaseOreRecipes() -> [Recipe] {
        var recipes: [Recipe] = []
        let ironOre = Recipe(type: "recipe", name: "iron-ore", category: .ore, ingredients: nil, energyRequired: nil, result: nil, normal: nil, expensive: nil, resultCount: nil, icon: "iron-ore", subgroup: nil, order: nil, results: nil)
        recipes.append(ironOre)

        let copperOre = Recipe(type: "recipe", name: "copper-ore", category: .ore, ingredients: nil, energyRequired: nil, result: nil, normal: nil, expensive: nil, resultCount: nil, icon: "copper-ore", subgroup: nil, order: nil, results: nil)
        recipes.append(copperOre)

        return recipes
    }

    func generateFillBarrelRecipes() -> [Recipe] {
        let fluids: [Fluid] = FluidParser.parseFluids()
        var recipes: [Recipe] = []

        let barrel = Ingredient(name: "empty-barrel", amount: 1, type: nil)

        for fluid in fluids {
            guard fluid.autoBarrel else { continue }
            let fluid = Ingredient(name: fluid.name, amount: 50, type: nil)
            let recipe = Recipe(type: "recipe", name: "\(fluid.name)-fill-barrel", category: .none, ingredients: [barrel, fluid], energyRequired: 0.2, result: "\(fluid.name)-fill-barrel", normal: nil, expensive: nil, resultCount: 1, icon: nil, subgroup: "fill-barrel", order: nil, results: nil)
            recipes.append(recipe)
        }
        return recipes
    }

    func generateEmptyBarrelRecipes() -> [Recipe] {
        let fluids: [Fluid] = FluidParser.parseFluids()
        var recipes: [Recipe] = []

        for fluid in fluids {
            guard fluid.autoBarrel else { continue }
            let fillBarrelIngredient = Ingredient(name: "\(fluid.name)-fill-barrel", amount: 1, type: nil)
            let results = [Result(name: "empty-barrel", probability: nil, amount: 1, type: nil, fluidbox_index: nil), Result(name: fluid.name, probability: nil, amount: 50, type: nil, fluidbox_index: nil)]
            let recipe = Recipe(type: "empty-barrel", name: "\(fluid.name)-empty-barrel", category: .none, ingredients: [fillBarrelIngredient], energyRequired: 0.2, result: nil, normal: nil, expensive: nil, resultCount: nil, icon: nil, subgroup: "empty-barrel", order: nil, results: results)
            recipes.append(recipe)
        }
        return recipes
    }

    func parseRecipe(from dict: [String: Any]) -> Recipe? {
        guard let type = dict[RecipeField.type.rawValue] as? String else { return nil }
        guard let name = dict[RecipeField.name.rawValue] as? String else { return nil }

        let category = Category.from(rawValue: dict[RecipeField.category.rawValue] as? String ?? "")
        let ingredients = parseIngredients(from: dict[RecipeField.ingredients.rawValue] as? [Any] ?? [])
        let energyRequired = dict[RecipeField.energyRequired.rawValue] as? Double ?? 0.5
        let result = dict[RecipeField.result.rawValue] as? String
        let normal: DifficultyRecipe? = parseDifficultyRecipe(from: dict[RecipeField.normal.rawValue] as? [String : Any])
        let expensive: DifficultyRecipe? = parseDifficultyRecipe(from: dict[RecipeField.expensive.rawValue] as? [String : Any])
        let resultCount = dict[RecipeField.resultCount.rawValue] as? Int ?? 1
        let icon = dict[RecipeField.icon.rawValue] as? String
        let subgroup = dict[RecipeField.subgroup.rawValue] as? String
        let order = dict[RecipeField.order.rawValue] as? String
        let results: [Result]? = parseResults(from: dict[RecipeField.results.rawValue] as? [Any] ?? [])

        let recipe = Recipe(type: type, name: name, category: category, ingredients: ingredients, energyRequired: energyRequired, result: result, normal: normal, expensive: expensive, resultCount: resultCount, icon: icon, subgroup: subgroup, order: order, results: results)

        return recipe
    }

    func parseIngredients(from array: [Any]) -> [Ingredient]? {
        guard !array.isEmpty else { return nil }
        var ingredients = [Ingredient]()
        for ingredientJson in array {
            if let arr = ingredientJson as? [Any] {
                guard let name = arr[0] as? String else { continue }
                guard let amount = arr[1] as? Int else { continue }
                let ingredient = Ingredient(name: name, amount: amount)
                ingredients.append(ingredient)
            } else if let dict = ingredientJson as? [String : Any] {
                guard let name = dict[IngredientField.name.rawValue] as? String else { continue }
                guard let amount = dict[IngredientField.amount.rawValue] as? Int else { continue }
                let type = dict[IngredientField.type.rawValue] as? String
                let ingredient = Ingredient(name: name, amount: amount, type: type)
                ingredients.append(ingredient)
            }
        }
        return ingredients
    }

    func parseDifficultyRecipe(from dict: [String : Any]?) -> DifficultyRecipe? {
        guard let dict = dict else { return nil }
        let enabled = dict[DifficultyRecipeField.enabled.rawValue] as? Bool
        let energyRequired = dict[DifficultyRecipeField.energyRequired.rawValue] as? Double
        let ingredients = parseIngredients(from: dict[DifficultyRecipeField.ingredients.rawValue] as? [Any] ?? [])
        let result = dict[DifficultyRecipeField.result.rawValue] as? String

        return DifficultyRecipe(enabled: enabled, energyRequired: energyRequired, ingredients: ingredients, result: result)
    }

    func parseColor(from dict: [String : Any]?) -> Color? {
        guard let dict = dict else { return nil }
        guard let r = dict["r"] as? Double else { return nil }
        guard let g = dict["g"] as? Double else { return nil }
        guard let b = dict["b"] as? Double else { return nil }
        guard let a = dict["a"] as? Double else { return nil }
        return Color(r: r, g: g, b: b, a: a)
    }

    func parseResults(from array: [Any]) -> [Result]? {

        var results = [Result]()
        for resultJson in array {
            if let data = resultJson as? [String : Any] {
                let name = data[ResultField.name.rawValue] as? String
                let probability = data[ResultField.probability.rawValue] as? Double
                let amount = data[ResultField.amount.rawValue] as? Int
                let type = data[ResultField.type.rawValue] as? String
                let fluidbox_index = data[ResultField.fluidboxIndex.rawValue] as? Int
                results.append(Result(name: name, probability: probability, amount: amount, type: type, fluidbox_index: fluidbox_index))
            }
        }
        return results
    }
}
