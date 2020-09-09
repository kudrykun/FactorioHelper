//
//  Recipe.swift
//  FactorioHelper
//
//  Created by Sergey Vasilenko on 03.09.2020.
//  Copyright © 2020 kudrykun. All rights reserved.
//

import Foundation

struct Recipe {
    var type: String
    var name: String
    var enabled: Bool? = false
    var category: Category = .Default
    private var ingredients: [Ingredient]? = nil
    private var energyRequired: Double
    var result: String? = nil
    var normal: DifficultyRecipe? = nil
    var expensive: DifficultyRecipe? = nil
    private var resultCount: Int
    var requester_paste_multiplier: Double? = nil //что это
    var crafting_machine_tint: CraftingMachineTint? = nil
    var hidden: Bool? = nil
    var icon: String? = nil
    var icon_size: String? = nil
    var icon_mipmaps: String? = nil
    var subgroup: String? = nil
    var order: String? = nil
    var results: [Result]? = nil

    var baseProductionTime: Double {
        let isExpensiveProduction = UserDefaults.standard.bool(forKey: "isExpensiveProduction")
        if let expensive = expensive?.energyRequired, isExpensiveProduction {
            return expensive
        }

        if let normal = normal?.energyRequired {
            return normal
        }
        return energyRequired
    }

    var baseIngredients: [Ingredient] {
        let isExpensiveProduction = UserDefaults.standard.bool(forKey: "isExpensiveProduction")
        if let expensive = expensive?.ingredients, isExpensiveProduction {
            return expensive
        }

        if let normal = normal?.ingredients {
            return normal
        }
        return ingredients ?? []
    }

    var baseProductionResultCount: Int {

        //нужно будет убрать default совсем
        switch category {
        case .Chemistry:
            //будет несколько элементов в results при обработке нефти
            guard let results = results, !results.isEmpty else { return resultCount }
            return results[0].amount ?? resultCount
        default:
            return resultCount
        }
    }

    init(type: String, name: String, enabled: Bool?, category: Category, ingredients: [Ingredient]?, energyRequired: Double, result: String?, normal: DifficultyRecipe?, expensive: DifficultyRecipe?, resultCount: Int, requester_paste_multiplier: Double?, crafting_machine_tint: CraftingMachineTint?, hidden: Bool?, icon: String?, icon_size: String?, icon_mipmaps: String?, subgroup: String?, order: String?, results: [Result]?) {
        self.type = type
        self.name = name
        self.enabled = enabled
        self.category = category
        self.ingredients = ingredients
        self.energyRequired = energyRequired
        self.result = result
        self.normal = normal
        self.expensive = expensive
        self.resultCount = resultCount
        self.requester_paste_multiplier = requester_paste_multiplier
        self.crafting_machine_tint = crafting_machine_tint
        self.hidden = hidden
        self.icon = icon
        self.icon_size = icon_size
        self.icon_mipmaps = icon_mipmaps
        self.subgroup = subgroup
        self.order = order
        self.results = results
    }

}

enum Category {
    case Default
    case RocketBuilding //rocket-building
    case OilProcessing //oil-processing
    case AdvancedCrafting //advanced-crafting
    case CraftingWithFluid //crafting-with-fluid
    case Smelting //smelting
    case Chemistry //chemistry
    case Crafting //crafting
    case Centrifuging //centrifuging
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
    var name: String?
    var probability: Double?
    var amount: Int?
    var type: String?
    var fluidbox_index: Int?
}
