//
//  ItemParser.swift
//  FactorioHelper
//
//  Created by Sergey Vasilenko on 20.09.2020.
//  Copyright © 2020 kudrykun. All rights reserved.
//

import Foundation

class ItemParser {
    private static let filenames = ["ammo", "armor", "capsule", "circuit-network", "demo-ammo", "demo-armor", "demo-gun", "demo-item-groups", "demo-item", "demo-module", "demo-turret", "equipment", "gun", "item", "mining-tools", "module1", "module2", "turret"]

    private static let exceptionItems = ["dummy-steel-axe", "blueprint", "deconstruction-planner", "upgrade-planner", "blueprint-book", "copy-paste-tool", "cut-paste-tool", "loader", "fast-loader", "express-loader", "small-plane", "wood", "coal", "stone", "iron-ore", "copper-ore", "uranium-ore"/*точно?*/, "raw-fish", "solid-fuel"/*точно?*/,"coin", "space-science-pack", "used-up-uranium-fuel-cell", "uranium-235", "uranium-238", "tank-machine-gun", "vehicle-machine-gun", "tank-flamethrower", "railgun", "artillery-wagon-cannon", "spidertron-rocket-launcher-1", "spidertron-rocket-launcher-2", "spidertron-rocket-launcher-3", "spidertron-rocket-launcher-4", "tank-cannon", "railgun-dart", "computer", "player-port"]

    static func getItems() -> [Item] {
        var items = [Item]()

        for filename in filenames {
            let fullFilename = filename

            guard let url = Bundle.main.url(forResource: fullFilename, withExtension: "json") else { return items }

            do {
                let data = try Data(contentsOf: url)
                guard let itemsArray = try JSONSerialization.jsonObject(with: data, options: []) as? [Any] else { return items }
                for itemJSON in itemsArray {
                    guard let itemJSON = itemJSON as? [String: Any] else { continue }
                    guard let item = parseItem(from: itemJSON) else { continue }
                    items.append(item)
                }
            } catch {
                print(error)
            }
        }

        items.append(contentsOf: getItemsFromRecipes())
        items.append(contentsOf: FluidItemsGenerator.generateFillBarrelItems(from: FluidParser.parseFluids()))
        items.append(contentsOf: FluidItemsGenerator.generateEmptyBarrelItems(from: FluidParser.parseFluids()))
        return items
    }
    

    private static func getItemsFromRecipes() -> [Item] {
        let recipes = RecipesProvider.getRecipes().filter{$0.subgroup != nil}
        let items = recipes.map { Item(type: $0.type, name: $0.name, subgroup: $0.subgroup ?? "", order: $0.order ?? "") }
        return items
    }

    private static func parseItem(from dict: [String: Any]) -> Item? {
        guard let type = dict["type"] as? String else { return nil }
        guard let name = dict["name"] as? String else { return nil }

        if name == "uranium-processing" {
            print("wow!")
        }

        guard !exceptionItems.contains(name) else { return nil }
        guard let order = dict["order"] as? String else { return nil }
        guard let subgroup = dict["subgroup"] as? String else { return nil }
        let icon = dict["icon"] as? String

        let group = Item(type: type, name: name, subgroup: subgroup, order: order, icon: icon)

        return group
    }

    /*
     struct Item {
         var type: String
         var name: String
         var subgroup: String
         var order: String
     }
     */

//    private static func arrangeGroups(_ groups: [Group]) -> [ String : Group ] {
//        var globalGroups: [String : Group] = [:]
//        for group in groups.filter({ $0.isGlobalGroup }) {
//            globalGroups[group.name] = group
//        }
//        var subgroups = groups.filter { !$0.isGlobalGroup }
//
//        for subgroup in subgroups {
//            guard let groupName = subgroup.group else { continue }
//            globalGroups[groupName]?.subgroups.append(subgroup)
//        }
//
//        return globalGroups
//    }
}
