//
//  RecipesProvider.swift
//  FactorioHelper
//
//  Created by Sergey Vasilenko on 05.09.2020.
//  Copyright © 2020 kudrykun. All rights reserved.
//

import Foundation

class RecipesProvider {
    private static var recipes: [Recipe] = []

    static func getRecipes() -> [Recipe] {
        if recipes.isEmpty {
            recipes = RecipeParser().parseRecipes()
        }
        recipes.sort { recipe1, recipe2 in
            let recipe1Name = NSLocalizedString(recipe1.name, comment: "")
            let recipe2Name = NSLocalizedString(recipe2.name, comment: "")
            return recipe1Name < recipe2Name
        }
        return recipes
    }

    static func findRecipe(with name: String) -> Recipe? {
        let recipes = RecipesProvider.getRecipes()
        guard let searchedRecipeIndex = recipes.firstIndex(where: { recipe in
            return recipe.name == name
        }) else { return nil }

        return recipes[searchedRecipeIndex]
    }
    
    static func getIngredients(for recipe: Recipe) -> [Ingredient] {
        var ingredients = recipe.ingredients
        if ingredients == nil {
            ingredients = recipe.normal?.ingredients
        }
        return ingredients ?? []
    }


}
