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
        let ingredients = parseIngedients(from: dict["ingredients"] as? [Any] ?? [])
        let energyRequired = dict["energyRequired"] as? Double
        let result = dict["result"] as? String
        let normal: DifficultyRecipe? = nil
        let expensive: DifficultyRecipe? = nil
        let resultCount = dict["resultCount"] as? Int
        let requester_paste_multiplier = dict["requester_paste_multiplier"] as? Double
        let crafting_machine_tint: CraftingMachineTint? = nil
        let hidden = dict["hidden"] as? Bool
        let icon = dict["icon"] as? String
        let icon_size = dict["icon_size"] as? String
        let icon_mipmaps = dict["icon_mipmaps"] as? String
        let subgroup = dict["subgroup"] as? String
        let order = dict["order"] as? String
        let results: [Result]? = nil

        let recipe = Recipe(type: type, name: name, enabled: enabled, category: category, ingredients: ingredients, energyRequired: energyRequired, result: result, normal: normal, expensive: expensive, resultCount: resultCount, requester_paste_multiplier: requester_paste_multiplier, crafting_machine_tint: crafting_machine_tint, hidden: hidden, icon: icon, icon_size: icon_size, icon_mipmaps: icon_mipmaps, subgroup: subgroup, order: order, results: results)

        return recipe
    }

    func parseIngedients(from array: [Any]) -> [Ingredient]? {
        var ingredients = [Ingredient]()
        for ingredientJson in array {
            if let arr = ingredientJson as? [Any] {
                guard let name = arr[0] as? String else { continue }
                guard let amount = arr[1] as? Int else { continue }
                let ingredient = Ingredient(name: name, amount: amount)
                ingredients.append(ingredient)
            } else if let dict = ingredientJson as? [String : Any] {
                guard let name = dict["type"] as? String else { continue }
                guard let amount = dict["amount"] as? Int else { continue }
                let type = dict["type"] as? String
                let ingredient = Ingredient(name: name, amount: amount, type: type)
                ingredients.append(ingredient)
            }
        }
        return ingredients
    }
}
