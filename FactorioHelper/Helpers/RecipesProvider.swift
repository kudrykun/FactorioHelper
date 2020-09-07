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
        return recipes
    }
}
