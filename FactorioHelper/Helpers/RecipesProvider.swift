//
//  RecipesProvider.swift
//  FactorioHelper
//
//  Created by Sergey Vasilenko on 05.09.2020.
//  Copyright © 2020 kudrykun. All rights reserved.
//

import Foundation

//TODO: сомневаюсь в необходимости этого класса
class RecipesProvider {
    private static var recipes: [Recipe] = []

    static func getRecipes() -> [Recipe] {
        if recipes.isEmpty {
            recipes = RecipeHelper.parseRecipes()
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
}
