//
//  Recipe.swift
//  FactorioHelper
//
//  Created by Sergey Vasilenko on 03.09.2020.
//  Copyright © 2020 kudrykun. All rights reserved.
//

import UIKit

public struct Recipe: Equatable {
    public static func == (lhs: Recipe, rhs: Recipe) -> Bool {
        return lhs.type == rhs.type && lhs.name == rhs.name && lhs.category == rhs.category
    }

    var type: String
    public var name: String
    var category: Category = .none
    private var ingredients: [Ingredient]? = nil
    private var energyRequired: Double?
    public var result: String? = nil
    var normal: DifficultyRecipe? = nil
    var expensive: DifficultyRecipe? = nil
    private var resultCount: Int?
    var icon: String? = nil
    public var subgroup: String? = nil
    var order: String? = nil
    public var results: [Result]? = nil

    public var baseProductionTime: Double {
        let isExpensiveProduction = UserDefaults.standard.bool(forKey: "isExpensiveProduction")
        if let expensive = expensive?.energyRequired, isExpensiveProduction {
            return expensive
        }

        if let normal = normal?.energyRequired {
            return normal
        }
        return energyRequired ?? 0
    }

    public var baseIngredients: [Ingredient] {
        let isExpensiveProduction = UserDefaults.standard.bool(forKey: "isExpensiveProduction")
        if let expensive = expensive?.ingredients, isExpensiveProduction {
            return expensive
        }

        if let normal = normal?.ingredients {
            return normal
        }
        return ingredients ?? []
    }

    public var baseProductionResultCount: Double {
        switch category {
        case .chemistry:
            guard let results = results, !results.isEmpty else { return Double(resultCount ?? 0)}
            return Double(results[0].amount ?? resultCount ?? 0)
        default:
            return Double(resultCount ?? 1)
        }
    }

    var localizedName: String {
        NSLocalizedString(name, comment: "")
    }

    var croppedIcon: UIImage? {
        if subgroup == "fill-barrel" {
            guard let range = name.range(of: "-fill-barrel") else { return nil }
            let fluidName = String(name[name.startIndex..<range.lowerBound])
            let fluid = FluidParser.parseFluids().filter{$0.name == fluidName}
            return IconsProvider.getFillBarrelIcon(for: fluid[0])
        } else if subgroup == "empty-barrel" {
            guard let range = name.range(of:"-empty-barrel") else { return nil }
            let fluidName = String(name[name.startIndex..<range.lowerBound])
            let fluid = FluidParser.parseFluids().filter{$0.name == fluidName}
            return IconsProvider.getEmptyBarrelIcon(for: fluid[0])
        } else {
            guard let sourceImage = UIImage(named: name) else { return nil }
            guard let croppedImage = IconsCropper.crop(sourceImage) else { return nil }
            return croppedImage
        }
    }

    init(type: String, name: String, category: Category, ingredients: [Ingredient]?, energyRequired: Double?, result: String?, normal: DifficultyRecipe?, expensive: DifficultyRecipe?, resultCount: Int?, icon: String?, subgroup: String?, order: String?, results: [Result]?) {
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
    case fluid
    case ore
    case rocketBuilding = "rocket-building"
    case oilProcessing = "oil-processing"
    case advancedCrafting = "advanced-crafting"
    case craftingWithFluid = "crafting-with-fluid"
    case smelting = "smelting"
    case chemistry = "chemistry"
    case crafting = "crafting"
    case centrifuging = "centrifuging"

    static func from(rawValue: String) -> Category {
        return Category(rawValue: rawValue) ?? .none
    }
}

public struct Ingredient: Codable, Equatable {
    public static func == (lhs: Ingredient, rhs: Ingredient) -> Bool {
        return lhs.name == rhs.name && lhs.amount == rhs.amount
    }

    public init(name: String, amount: Int, type: String? = nil) {
        self.name = name
        self.amount = amount
        self.type = type
    }

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
    }
}

public struct Result: Codable, Equatable {
    public static func == (lhs: Result, rhs: Result) -> Bool {
        return lhs.name == rhs.name && lhs.amount == rhs.amount
    }

    public init(name: String?, probability: Double?, amount: Int?, type: String?, fluidbox_index: Int?) {
        self.name = name
        self.probability = probability
        self.amount = amount
        self.type = type
        self.fluidbox_index = fluidbox_index
    }

    var name: String? = nil
    var probability: Double? = nil
    var amount: Int? = nil
    var type: String? = nil
    var fluidbox_index: Int? = nil
}
