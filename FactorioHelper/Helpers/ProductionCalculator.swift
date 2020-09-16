//
//  ProductionCalculator.swift
//  FactorioHelper
//
//  Created by Sergey Vasilenko on 07.09.2020.
//  Copyright © 2020 kudrykun. All rights reserved.
//

import UIKit

//не парсится, нужна проверка после обновления версии игры
enum MachineType {
    case Machine1
    case Machine2
    case Machine3
    case OilRefinery
    case ChemicalPlant
    case Centrifuge
    case StoneFurnace
    case SteelFurnace
    case ElectricFurnace

    var speedMultipier: Double {
        switch self {
        case .Machine1: return 0.5
        case .Machine2: return 0.75
        case .Machine3: return 1.25
        case .OilRefinery: return 1.0
        case .ChemicalPlant: return 1.0
        case .Centrifuge: return 1.0
        case .StoneFurnace: return 1
        case .SteelFurnace: return 2
        case .ElectricFurnace: return 2
        }
    }

    var maximumComponentsCount: Int {
        switch self {
        case .Machine1: return 2
        case .Machine2: return 4
        case .Machine3: return 6
        case .OilRefinery: return 3 //проверить
        case .ChemicalPlant: return 2 //проверить
        case .Centrifuge: return 2
        case .StoneFurnace: return 1
        case .SteelFurnace: return 1
        case .ElectricFurnace: return 1
        }
    }

    var isLiquidEnabled: Bool {
        switch self {
        case .Machine1, .Centrifuge, .StoneFurnace, .SteelFurnace, .ElectricFurnace: return false
        case .Machine2, .Machine3, .OilRefinery, .ChemicalPlant: return true
        }
    }

    var modulesCount: Int {
        switch self {
        case .Machine1: return 0
        case .Machine2: return 2
        case .Machine3: return 4
        case .OilRefinery: return 3
        case .ChemicalPlant: return 3
        case .Centrifuge: return 2
        case .StoneFurnace: return 0
        case .SteelFurnace: return 0
        case .ElectricFurnace: return 2
        }
    }

    var minimalEnergyConsumption: Int {
        switch self {
        case .Machine1: return 2500
        case .Machine2: return 5000
        case .Machine3: return 12500
        case .OilRefinery: return 14000
        case .ChemicalPlant: return 7000
        case .Centrifuge: return 11670
        case .StoneFurnace: return 90000
        case .SteelFurnace: return 90000
        case .ElectricFurnace: return 6000
        }
    }

    var maximumEnergyConsumption: Int {
        switch self {
        case .Machine1: return 77500
        case .Machine2: return 15500
        case .Machine3: return 388000
        case .OilRefinery: return 434000
        case .ChemicalPlant: return 217000
        case .Centrifuge: return 362000
        case .StoneFurnace: return 90000
        case .SteelFurnace: return 90000
        case .ElectricFurnace: return 186000
        }
    }

    var icon: UIImage {
        return IconProvider.getImage(for: self) ?? UIImage()
    }

    var name: String {
        switch self {
        case .Machine1: return "assembling-machine-1"
        case .Machine2: return "assembling-machine-2"
        case .Machine3: return "assembling-machine-3"
        case .OilRefinery: return "oil-refinery"
        case .ChemicalPlant: return "chemical-plant"
        case .Centrifuge: return "centrifuge"
        case .StoneFurnace: return "stone-furnace"
        case .SteelFurnace: return "steel-furnace"
        case .ElectricFurnace: return "electric-furnace"
        }
    }

    var localizedName: String {
        return NSLocalizedString(name, comment: "")
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
        let ingredients = recipe.baseIngredients
        guard !ingredients.isEmpty else  {
            let item = ProductionItem(name: recipe.name, countPerSecond: countPerSecond, ingredients: [])
            return item
        }

        let machineType = getMachineType(for: recipe)
        let baseProductionPerSecond = Double(recipe.baseProductionResultCount) / recipe.baseProductionTime
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

    static func getMachineType(for recipe: Recipe) -> MachineType {
        switch recipe.category {
        case .Default, .Crafting, .RocketBuilding, .AdvancedCrafting, .CraftingWithFluid: return .Machine1
        case .OilProcessing: return .OilRefinery
        case .Smelting: return .StoneFurnace
        case .Chemistry: return .ChemicalPlant
        case .Centrifuging: return .Centrifuge
        }
    }

    static func getPossibleMachineTypes(for recipe: Recipe) -> [MachineType] {
        switch recipe.category {
        case .Default, .Crafting, .RocketBuilding, .AdvancedCrafting, .CraftingWithFluid:
            let ingredients = recipe.baseIngredients
            var machines = [MachineType]()
            if ingredients.count <= 2 && (ingredients.filter{ $0.type == "fluid" }).isEmpty {
                machines.append(.Machine1)
            }
            if ingredients.count <= 4 {
                machines.append(.Machine2)
            }

            if ingredients.count <= 6 {
                machines.append(.Machine3)
            }
            return machines
        case .OilProcessing: return [.OilRefinery]
        case .Smelting: return [.StoneFurnace, .SteelFurnace, .ElectricFurnace]
        case .Chemistry: return [.ChemicalPlant]
        case .Centrifuging: return [.Centrifuge]
        }
    }
}
