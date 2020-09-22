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

        return items
    }

    private static func parseItem(from dict: [String: Any]) -> Item? {

        guard let type = dict["type"] as? String else { return nil }
        guard let name = dict["name"] as? String else { return nil }
        guard let order = dict["order"] as? String else { return nil }
        guard let subgroup = dict["subgroup"] as? String else { return nil }

        let group = Item(type: type, name: name, subgroup: subgroup, order: order)

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
