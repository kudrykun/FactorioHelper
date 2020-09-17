//
//  ProductionCalculator.swift
//  FactorioHelper
//
//  Created by Sergey Vasilenko on 07.09.2020.
//  Copyright © 2020 kudrykun. All rights reserved.
//

import UIKit

struct ProductionItem {
    var name: String
    var countPerSecond: Double
    var machinesNeeded: Double?
    var machineType: MachineType
    var recipe: Recipe
}

class ProductionCalculator {
    static func getProductionItem(for recipe: Recipe, countPerSecond: Double) -> TreeNode<ProductionItem>?{
        let ingredients = recipe.baseIngredients

        let machineType = getMachineType(for: recipe)
        let baseProductionPerSecond = Double(recipe.baseProductionResultCount) / recipe.baseProductionTime
        let productionByOneMachinePerSecond = baseProductionPerSecond * machineType.speedMultipier
        let requiredMachinesCount = countPerSecond / productionByOneMachinePerSecond
        let roundedRequiredMachinesCount = Int(requiredMachinesCount.rounded(.up))


        let productionItem = ProductionItem(name: recipe.name, countPerSecond: countPerSecond, machinesNeeded: requiredMachinesCount, machineType: machineType, recipe: recipe)
        let treeRoot = TreeNode<ProductionItem>(productionItem)

        for ingredient in ingredients {
            guard let recipe = RecipesProvider.findRecipe(with: ingredient.name) else { continue }
            let itemsPerSecondCount = Double(roundedRequiredMachinesCount) * Double(ingredient.amount)
            let ingredientProductionItem = getProductionItem(for: recipe, countPerSecond: itemsPerSecondCount)
            if let ingredientProductionItem = ingredientProductionItem {
                let treeNode = ingredientProductionItem
                treeRoot.addChild(treeNode)
            }
        }

        return treeRoot
    }

    static func getRecalculatedProductionItem(item: TreeNode<ProductionItem>, countPerSecond: Double) -> TreeNode<ProductionItem> {
        let ingredients = item.value.recipe.baseIngredients

        let machineType = item.value.machineType
        let baseProductionPerSecond = Double(item.value.recipe.baseProductionResultCount) / item.value.recipe.baseProductionTime
        let productionByOneMachinePerSecond = baseProductionPerSecond * machineType.speedMultipier
        let requiredMachinesCount = countPerSecond / productionByOneMachinePerSecond
        let roundedRequiredMachinesCount = Int(requiredMachinesCount.rounded(.up))

        item.value.countPerSecond = countPerSecond
        item.value.machinesNeeded = requiredMachinesCount

        for ingredient in ingredients {
            guard let node = (item.children.first{$0.value.name == ingredient.name}) else { continue }
            let itemsPerSecondCount = Double(roundedRequiredMachinesCount) * Double(ingredient.amount)
            let ingredientProductionItem = getRecalculatedProductionItem(item: node, countPerSecond: itemsPerSecondCount)
            for i in 0..<item.children.count {
                if item.children[i].value.name == node.value.name {
                    item.children[i] = ingredientProductionItem
                }
            }
        }


        return item
    }




    static private func getTotalMachinesCount(for item: ProductionItem) -> Int {
        guard let machinesNeeded = item.machinesNeeded else { return 0 }
        var totalCount = Int(machinesNeeded.rounded(.up))
//        item.ingredients.forEach { item in
//            totalCount += getTotalMachinesCount(for: item)
//        }
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
