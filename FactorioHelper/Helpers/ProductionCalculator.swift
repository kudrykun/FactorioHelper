//
//  ProductionCalculator.swift
//  FactorioHelper
//
//  Created by Sergey Vasilenko on 07.09.2020.
//  Copyright © 2020 kudrykun. All rights reserved.
//

import UIKit

public struct ProductionItem: Equatable, Comparable{
    public static func < (lhs: ProductionItem, rhs: ProductionItem) -> Bool {
        return lhs.name < rhs.name
    }

    public var name: String
    var countPerSecond: Double
    var machinesNeeded: Double?
    public var machineType: MachineType?
    var recipe: Recipe
    var nestingLevel: Int
    var collapsed: Bool = false
    var collapsedDescendants: Bool = false

    public init(name: String, countPerSecond: Double, machinesNeeded: Double?, machineType: MachineType?, recipe: Recipe, nestingLevel: Int) {
        self.name = name
        self.countPerSecond = countPerSecond
        self.machinesNeeded = machinesNeeded
        self.machineType = machineType
        self.recipe = recipe
        self.nestingLevel = nestingLevel
    }

    public static func == (lhs: ProductionItem, rhs: ProductionItem) -> Bool {
        return lhs.name == rhs.name &&
            lhs.countPerSecond == rhs.countPerSecond &&
            lhs.machinesNeeded == rhs.machinesNeeded &&
            lhs.machineType == rhs.machineType &&
            lhs.recipe == rhs.recipe &&
            lhs.nestingLevel == rhs.nestingLevel
    }
}

public struct MachinesSet: Equatable {
    var type: MachineType
    var count: Int
}

public class ProductionCalculator {
    public static func getProductionItem(for recipe: Recipe, countPerSecond: Double, nestingLevel: Int) -> TreeNode<ProductionItem>?{
        let ingredients = recipe.baseIngredients

        if ingredients.isEmpty {
            let machineType = getPossibleMachineTypes(for: recipe).first
            let productionItem = ProductionItem(name: recipe.name, countPerSecond: countPerSecond, machinesNeeded: nil, machineType: machineType, recipe: recipe, nestingLevel: nestingLevel)
            let treeRoot = TreeNode<ProductionItem>(productionItem)
            return treeRoot
        }

        guard let machineType = getPossibleMachineTypes(for: recipe).first else { return nil }
        let baseProductionPerSecond = Double(recipe.baseProductionResultCount) / recipe.baseProductionTime
        let productionByOneMachinePerSecond = baseProductionPerSecond * machineType.speedMultipier
        let requiredMachinesCount = countPerSecond / productionByOneMachinePerSecond
        let roundedRequiredMachinesCount = Int(requiredMachinesCount.rounded(.up))


        let productionItem = ProductionItem(name: recipe.name, countPerSecond: countPerSecond, machinesNeeded: Double(roundedRequiredMachinesCount), machineType: machineType, recipe: recipe, nestingLevel: nestingLevel)
        let treeRoot = TreeNode<ProductionItem>(productionItem)

        for ingredient in ingredients {
            guard let recipe = RecipesProvider.recipes[ingredient.name] else { continue }
            let itemsPerSecondCount = Double(roundedRequiredMachinesCount) * Double(ingredient.amount)
            let ingredientProductionItem = getProductionItem(for: recipe, countPerSecond: itemsPerSecondCount, nestingLevel: nestingLevel + 1)
            if let ingredientProductionItem = ingredientProductionItem {
                let treeNode = ingredientProductionItem
                treeRoot.addChild(treeNode)
            }
        }

        return treeRoot
    }

    static func getRecalculatedProductionItem(item: TreeNode<ProductionItem>, countPerSecond: Double) -> TreeNode<ProductionItem> {
        let ingredients = item.value.recipe.baseIngredients

        guard let machineType = item.value.machineType else { return item }
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
        return totalCount
    }

    public static func getMachineType(for recipe: Recipe) -> MachineType {
        switch recipe.category {
        case .none, .crafting, .rocketBuilding, .advancedCrafting, .craftingWithFluid: return .Machine1
        case .oilProcessing: return .OilRefinery
        case .smelting: return .StoneFurnace
        case .chemistry: return .ChemicalPlant
        case .centrifuging: return .Centrifuge
        case .fluid, .ore: return .Machine1 //TODO: что то не так
        }
    }

    public static func getPossibleMachineTypes(for recipe: Recipe) -> [MachineType] {
        switch recipe.category {
        case .none, .crafting, .rocketBuilding, .advancedCrafting, .craftingWithFluid:
            let ingredients = recipe.baseIngredients
            var machines = [MachineType]()
            if ingredients.filter({ $0.type == "fluid" }).isEmpty {
                machines.append(.Machine1)
            }
            machines.append(.Machine2)
            machines.append(.Machine3)
            return machines
        case .oilProcessing: return [.OilRefinery]
        case .smelting: return [.StoneFurnace, .SteelFurnace, .ElectricFurnace]
        case .chemistry: return [.ChemicalPlant]
        case .centrifuging:
            if recipe.name == "uranium-238" || recipe.name == "uranium-235" {
                return []
            }
            return [.Centrifuge]
        case .fluid, .ore: return [] //TODO: что то не так
        }
    }

    public static func getMachinesCountSet(for item: TreeNode<ProductionItem>) -> [MachinesSet] {
        let dict: [MachineType : Int] = getMachinesCountSet(for: item)
        let array = dict.map {MachinesSet(type: $0.key, count: $0.value)}
        return array.sorted(by: { $0.type.rawValue < $1.type.rawValue })
    }

    private static func getMachinesCountSet(for item: TreeNode<ProductionItem>) -> [MachineType : Int] {
        guard let machinesNeeded = item.value.machinesNeeded else { return [:] }
        guard let machinesType = item.value.machineType else { return [:] }
        let machinesNeededRounded = Int(machinesNeeded.rounded(.up))
        var resultDict = [machinesType : machinesNeededRounded]
        item.children.forEach { child in
            let childDict: [MachineType : Int] = ProductionCalculator.getMachinesCountSet(for: child)
            resultDict.merge(childDict, uniquingKeysWith: { first, second in
                return first + second
            })
        }
        return resultDict
    }
}
