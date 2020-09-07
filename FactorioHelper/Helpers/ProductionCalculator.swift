//
//  ProductionCalculator.swift
//  FactorioHelper
//
//  Created by Sergey Vasilenko on 07.09.2020.
//  Copyright © 2020 kudrykun. All rights reserved.
//

import Foundation

enum MachineType {
    case Machine1
    case Machine2
    case Machine3

    var speedMultipier: Double {
        switch self {
        case .Machine1: return 0.5
        case .Machine2: return 0.75
        case .Machine3: return 1.25
        }
    }

    var maximumComponentsCount: Int {
        switch self {
        case .Machine1: return 2
        case .Machine2: return 4
        case .Machine3: return 6
        }
    }

    var isLiquidEnabled: Bool {
        switch self {
        case .Machine1: return false
        case .Machine2, .Machine3: return true
        }
    }

    var modulesCount: Int {
        switch self {
        case .Machine1: return 0
        case .Machine2: return 2
        case .Machine3: return 4
        }
    }

    var energyConsumption: Int {
        switch self {
        case .Machine1: return 90000
        case .Machine2: return 150000
        case .Machine3: return 210000
        }
    }
}

struct ProductionItem {
    var name: String
    var countPerSecond: Double
    var machinesNeeded: Double?
    var ingredients: [ProductionItem]
    var machineType: MachineType = .Machine1
}

class ProductionCalculator {
    static func getProductionItem(for recipe: Recipe, countPerSecond: Double) -> ProductionItem?{
        let ingredients = RecipesProvider.getIngredients(for: recipe)
        guard !ingredients.isEmpty else  {
            let item = ProductionItem(name: recipe.name, countPerSecond: countPerSecond, ingredients: [])
            return item
        }

        let machineType = MachineType.Machine1
        let baseProductionPerSecond = Double(recipe.resultCount) / recipe.energyRequired
        let productionByOneMachinePerSecond = baseProductionPerSecond * machineType.speedMultipier
        let requiredMachinesCount = countPerSecond / productionByOneMachinePerSecond
        let roundedRequiredMachinesCount = Int(requiredMachinesCount.rounded(.up))
        var ingredientsProduction = [ProductionItem]()
        for ingredient in ingredients {
            guard let recipe = RecipesProvider.findRecipe(with: ingredient.name) else { continue }
            let itemsPerSecondCount = Double(roundedRequiredMachinesCount) * Double(ingredient.amount)
            let ingredientProductionItem = getProductionItem(for: recipe, countPerSecond: itemsPerSecondCount)
            if let ingredientProductionItem = ingredientProductionItem {
                ingredientsProduction.append(ingredientProductionItem)
            }
        }

        let productionItem = ProductionItem(name: recipe.name, countPerSecond: countPerSecond, machinesNeeded: requiredMachinesCount, ingredients: ingredientsProduction)
        return productionItem
    }

    static func getProductionDescriptionString(for item: ProductionItem, nestingLevel: Int = 0) -> String {
        guard let _ = item.machinesNeeded else { return "" } 
        var resultString = ""
        if nestingLevel == 0 {
            resultString.append("Всего нужно машин: \(getTotalMachinesCount(for: item))\n")
        }
        for _ in 0..<nestingLevel {
            resultString.append("\t")
        }

        guard let machinesNeeded = item.machinesNeeded else { return resultString }

        resultString.append("\(Int(machinesNeeded.rounded(.up))) машин для \(Int(item.countPerSecond.rounded(.up))) \(item.name)\n")

        for item in item.ingredients {
            resultString.append(getProductionDescriptionString(for: item, nestingLevel: nestingLevel + 1))
        }
        return resultString
    }

    static private func getTotalMachinesCount(for item: ProductionItem) -> Int {
        guard let machinesNeeded = item.machinesNeeded else { return 0 }
        var totalCount = Int(machinesNeeded.rounded(.up))
        item.ingredients.forEach { item in
            totalCount += getTotalMachinesCount(for: item)
        }
        return totalCount
    }
}
