//
//  RecipeParser.swift
//  FactorioHelper
//
//  Created by Sergey Vasilenko on 03.09.2020.
//  Copyright © 2020 kudrykun. All rights reserved.
//

import Foundation

class RecipeParser {
    let filenames = ["ammo", "capsule", "circuit-network", "demo-furnace-recipe", "demo-recipe", "demo-turret", "equipment", "fluid-recipe", "inserter", "module", "recipe", "turret"]

    func parseRecipes() -> [Recipe] {
        var recipes = [Recipe]()

        for filename in filenames {
            let fullFilename = filename + "JSONED"

            guard let url = Bundle.main.url(forResource: fullFilename, withExtension: "json") else { return recipes }

            do {
                let data = try Data(contentsOf: url)
                guard let recipesArray = try JSONSerialization.jsonObject(with: data, options: []) as? [Any] else { return recipes }
                for recipeJSON in recipesArray {
                    guard let recipeJSON = recipeJSON as? [String: Any] else { continue }
                    guard let recipe = parseRecipe(from: recipeJSON) else { continue }
                    recipes.append(recipe)
                }
            } catch {
                print(error)
            }
        }

        return recipes
    }

    func parseRecipe(from dict: [String: Any]) -> Recipe? {
        guard let type = dict["type"] as? String else { return nil }
        guard let name = dict["name"] as? String else { return nil }
        let enabled = dict["enabled"] as? Bool
        let category = dict["category"] as? String
        var ingredients: [Ingredient]?
        if category != "smelting" {
            ingredients = parseIngedients(from: dict["ingredients"] as? [Any] ?? [])
        }
        let energyRequired = dict["energy_required"] as? Double ?? 0.5
        let result = dict["result"] as? String
        let normal: DifficultyRecipe? = parseDifficultyRecipe(from: dict["normal"] as? [String : Any])
        let expensive: DifficultyRecipe? = parseDifficultyRecipe(from: dict["expensive"] as? [String : Any])
        let resultCount = dict["result_count"] as? Int ?? 1
        let requester_paste_multiplier = dict["requester_paste_multiplier"] as? Double
        let crafting_machine_tint: CraftingMachineTint? = parseCraftingMachineTint(from: dict["crafting_machine_tint"] as? [String : Any])
        let hidden = dict["hidden"] as? Bool
        let icon = dict["icon"] as? String
        let icon_size = dict["icon_size"] as? String
        let icon_mipmaps = dict["icon_mipmaps"] as? String
        let subgroup = dict["subgroup"] as? String
        let order = dict["order"] as? String
        let results: [Result]? = parseResults(from: dict["results"] as? [Any] ?? [])

        let recipe = Recipe(type: type, name: name, enabled: enabled, category: category, ingredients: ingredients, energyRequired: energyRequired, result: result, normal: normal, expensive: expensive, resultCount: resultCount, requester_paste_multiplier: requester_paste_multiplier, crafting_machine_tint: crafting_machine_tint, hidden: hidden, icon: icon, icon_size: icon_size, icon_mipmaps: icon_mipmaps, subgroup: subgroup, order: order, results: results)

        return recipe
    }

    func parseIngedients(from array: [Any]) -> [Ingredient]? {
        guard !array.isEmpty else { return nil }
        var ingredients = [Ingredient]()
        for ingredientJson in array {
            if let arr = ingredientJson as? [Any] {
                guard let name = arr[0] as? String else { continue }
                guard let amount = arr[1] as? Int else { continue }
                let ingredient = Ingredient(name: name, amount: amount)
                ingredients.append(ingredient)
            } else if let dict = ingredientJson as? [String : Any] {
                guard let name = dict["name"] as? String else { continue }
                guard let amount = dict["amount"] as? Int else { continue }
                let type = dict["type"] as? String
                let ingredient = Ingredient(name: name, amount: amount, type: type)
                ingredients.append(ingredient)
            }
        }
        return ingredients
    }

    func parseDifficultyRecipe(from dict: [String : Any]?) -> DifficultyRecipe? {
        guard let dict = dict else { return nil }
        let enabled = dict["enabled"] as? Bool
        let energyRequired = dict["energyRequired"] as? Double ?? 0.5
        let ingredients = parseIngedients(from: dict["ingredients"] as? [Any] ?? [])
        let result = dict["result"] as? String

        return DifficultyRecipe(enabled: enabled, energyRequired: energyRequired, ingredients: ingredients, result: result)
    }

    func parseColor(from dict: [String : Any]?) -> Color? {
        guard let dict = dict else { return nil }
        let r = dict["r"] as! Double
        let g = dict["g"] as! Double
        let b = dict["b"] as! Double
        let a = dict["a"] as! Double
        return Color(r: r, g: g, b: b, a: a)
    }

    func parseCraftingMachineTint(from dict: [String : Any]?) -> CraftingMachineTint? {
        guard let dict = dict else { return nil }
        guard let primary = parseColor(from: dict["primary"] as? [String : Any]) else { return nil }
        guard let secondary = parseColor(from: dict["secondary"] as? [String : Any]) else { return nil }
        guard let tertiary = parseColor(from: dict["tertiary"] as? [String : Any]) else { return nil }
        guard let quaternary = parseColor(from: dict["quaternary"] as? [String : Any]) else { return nil }
        return CraftingMachineTint(primary: primary, secondary: secondary, tertiary: tertiary, quaternary: quaternary)
    }

    func parseResults(from array: [Any]) -> [Result]? {

        var results = [Result]()
        for resultJson in array {
            if let data = resultJson as? [String : Any] {
                let name = data["name"] as? String
                let probability = data["probability"] as? Double
                let amount = data["amount"] as? Int
                let type = data["type"] as? String
                let fluidbox_index = data["fluidbox_index"] as? Int
                results.append(Result(name: name, probability: probability, amount: amount, type: type, fluidbox_index: fluidbox_index))
            }
        }
        return results
    }
}
