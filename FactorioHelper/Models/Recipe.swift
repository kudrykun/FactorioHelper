//
//  Recipe.swift
//  FactorioHelper
//
//  Created by Sergey Vasilenko on 03.09.2020.
//  Copyright © 2020 kudrykun. All rights reserved.
//

import UIKit

struct Recipe {
    var type: String
    var name: String
    var category: Category = .none
    private var ingredients: [Ingredient]? = nil
    private var energyRequired: Double
    var result: String? = nil
    var normal: DifficultyRecipe? = nil
    var expensive: DifficultyRecipe? = nil
    private var resultCount: Int
    var icon: String? = nil
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
        case .chemistry:
            //будет несколько элементов в results при обработке нефти
            guard let results = results, !results.isEmpty else { return resultCount }
            return results[0].amount ?? resultCount
        default:
            return resultCount
        }
    }

    var localizedName: String {
        NSLocalizedString(name, comment: "")
    }

    var croppedIcon: UIImage? {
        guard let sourceImage = UIImage(named: name) else { return nil }
        guard let croppedImage = IconsCropper.crop(sourceImage) else { return nil }
        return croppedImage
    }

    init(type: String, name: String, category: Category, ingredients: [Ingredient]?, energyRequired: Double, result: String?, normal: DifficultyRecipe?, expensive: DifficultyRecipe?, resultCount: Int, icon: String?, subgroup: String?, order: String?, results: [Result]?) {
        self.type = type
        self.name = name
        self.category = category
        self.ingredients = ingredients
        self.energyRequired = energyRequired
        self.result = result
        self.normal = normal
        self.expensive = expensive
        self.resultCount = resultCount
        self.icon = icon
        self.subgroup = subgroup
        self.order = order
        self.results = results
    }

}

enum Category: String {
    case none
    case rocketBuilding = "rocket-building"
    case oilProcessing = "oil-processing"
    case advancedCrafting = "advanced-crafting"
    case craftingWithFluid = "crafting-with-fluid"
    case smelting = "smelting"
    case chemistry = "chemistry"
    case crafting = "crafting"
    case centrifuging = "centrifuging"
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

struct Color {
    var r: Double
    var g: Double
    var b: Double
    var a: Double?

    var uiColor: UIColor {
        return UIColor(red: CGFloat(r), green: CGFloat(g), blue: CGFloat(b), alpha: CGFloat(a ?? 1.0))
//        return UIColor(red: r, green: g, blue: b, alpha: a ?? 1.0)
    }
}

struct Result: Codable {
    var name: String?
    var probability: Double?
    var amount: Int?
    var type: String?
    var fluidbox_index: Int?
}
