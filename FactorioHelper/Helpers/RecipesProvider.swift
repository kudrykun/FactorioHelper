//
//  RecipesProvider.swift
//  FactorioHelper
//
//  Created by Sergey Vasilenko on 05.09.2020.
//  Copyright © 2020 kudrykun. All rights reserved.
//

import Foundation

class RecipesProvider {
    private static var innerRecipes: [String : Recipe] = [:]
    public static var recipes: [String : Recipe] {
        get {
            if innerRecipes.isEmpty {
                innerRecipes = RecipeParser().parseRecipes()
            }
            return innerRecipes
        }
    }
}
