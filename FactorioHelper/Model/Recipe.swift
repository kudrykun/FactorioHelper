//
//  Recipe.swift
//  FactorioHelper
//
//  Created by Sergey Vasilenko on 03.09.2020.
//  Copyright © 2020 kudrykun. All rights reserved.
//

import Foundation

struct Recipe: Codable {
    var type: String
    var name: String
    var enabled: Bool? = false
    var category: String? = nil
    var ingredients: [Ingredient]? = nil
    var energyRequired: Double? = nil
    var result: String? = nil
    var normal: DifficultyRecipe? = nil
    var expensive: DifficultyRecipe? = nil
    var resultCount: Int? = nil //что это
    var requester_paste_multiplier: Double? = nil //что это
    var crafting_machine_tint: CraftingMachineTint? = nil
    var hidden: Bool? = nil
    var icon: String? = nil
    var icon_size: String? = nil
    var icon_mipmaps: String? = nil
    var subgroup: String? = nil
    var order: String? = nil
    var results: [Result]? = nil
}




struct Ingredient: Codable {
    var name: String
    var amount: Int
    var type: String? = nil
}

struct DifficultyRecipe: Codable {
    var enabled: Bool? = false
    var energyRequired: Double? = nil
    var ingredients: [Ingredient]? = nil
    var result: String? = nil
}

struct CraftingMachineTint: Codable {
    var primary: Color
    var secondary: Color
    var tertiary: Color
    var quaternary: Color
}

struct Color: Codable {
    var r: Double
    var g: Double
    var b: Double
    var a: Double
}

struct Result: Codable {
    var name: String
    var probability: Double
    var amount: Int
}
