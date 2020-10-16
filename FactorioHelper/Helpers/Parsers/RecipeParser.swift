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
        case enabled = "enabled"
        case category = "category"
        case ingredients = "ingredients"
        case energyRequired = "energy_required"
        case result = "result"
        case normal = "normal"
        case expensive = "expensive"
        case resultCount = "result_count"
        case requesterPasteMultiplier = "requester_paste_multiplier"
        case craftingMachineTint = "crafting_machine_tint"
        case hidden = "hidden"
        case icon = "icon"
        case iconSize = "icon_size"
        case iconMipmaps = "icon_mipmaps"
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

        return recipes
    }

    func parseRecipe(from dict: [String: Any]) -> Recipe? {
        guard let type = dict[RecipeField.type.rawValue] as? String else { return nil }
        guard let name = dict[RecipeField.name.rawValue] as? String else { return nil }

        let enabled = dict[RecipeField.enabled.rawValue] as? Bool
        let category = parseCategory(from: dict[RecipeField.category.rawValue] as? String)
        var ingredients: [Ingredient]?
        if category != .smelting { //зачем
            ingredients = parseIngredients(from: dict[RecipeField.ingredients.rawValue] as? [Any] ?? [])
        }
        let energyRequired = dict[RecipeField.energyRequired.rawValue] as? Double ?? 0.5
        let result = dict[RecipeField.result.rawValue] as? String
        let normal: DifficultyRecipe? = parseDifficultyRecipe(from: dict[RecipeField.normal.rawValue] as? [String : Any])
        let expensive: DifficultyRecipe? = parseDifficultyRecipe(from: dict[RecipeField.expensive.rawValue] as? [String : Any])
        let resultCount = dict[RecipeField.resultCount.rawValue] as? Int ?? 1
        let requester_paste_multiplier = dict[RecipeField.requesterPasteMultiplier.rawValue] as? Double
        let crafting_machine_tint: CraftingMachineTint? = parseCraftingMachineTint(from: dict[RecipeField.craftingMachineTint.rawValue] as? [String : Any])
        let hidden = dict[RecipeField.hidden.rawValue] as? Bool
        let icon = dict[RecipeField.icon.rawValue] as? String
        let icon_size = dict[RecipeField.iconSize.rawValue] as? String
        let icon_mipmaps = dict[RecipeField.iconMipmaps.rawValue] as? String
        let subgroup = dict[RecipeField.subgroup.rawValue] as? String
        let order = dict[RecipeField.order.rawValue] as? String
        let results: [Result]? = parseResults(from: dict[RecipeField.results.rawValue] as? [Any] ?? [])

        let recipe = Recipe(type: type, name: name, enabled: enabled, category: category, ingredients: ingredients, energyRequired: energyRequired, result: result, normal: normal, expensive: expensive, resultCount: resultCount, requester_paste_multiplier: requester_paste_multiplier, crafting_machine_tint: crafting_machine_tint, hidden: hidden, icon: icon, icon_size: icon_size, icon_mipmaps: icon_mipmaps, subgroup: subgroup, order: order, results: results)

        return recipe
    }

    //TODO: найди способ аккуратнее
    func parseCategory(from string: String?) -> Category {
        guard let category = string else { return .default}
        switch category {
        case Category.rocketBuilding.rawValue:
            return .rocketBuilding
        case Category.oilProcessing.rawValue:
            return .oilProcessing
        case Category.advancedCrafting.rawValue:
            return .advancedCrafting
        case Category.craftingWithFluid.rawValue:
            return .craftingWithFluid
        case Category.smelting.rawValue:
            return .smelting
        case Category.chemistry.rawValue:
            return .chemistry
        case Category.crafting.rawValue:
            return .crafting
        case Category.centrifuging.rawValue:
            return .centrifuging
        default:
            return .default
        }
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

    func parseCraftingMachineTint(from dict: [String : Any]?) -> CraftingMachineTint? {
        guard let dict = dict else { return nil }
        guard let primary = parseColor(from: dict[MachineTineField.primary.rawValue] as? [String : Any]) else { return nil }
        guard let secondary = parseColor(from: dict[MachineTineField.secondary.rawValue] as? [String : Any]) else { return nil }
        guard let tertiary = parseColor(from: dict[MachineTineField.tertiary.rawValue] as? [String : Any]) else { return nil }
        guard let quaternary = parseColor(from: dict[MachineTineField.quaternary.rawValue] as? [String : Any]) else { return nil }
        return CraftingMachineTint(primary: primary, secondary: secondary, tertiary: tertiary, quaternary: quaternary)
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
