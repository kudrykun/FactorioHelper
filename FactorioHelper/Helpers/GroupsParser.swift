//
//  GroupsParser.swift
//  FactorioHelper
//
//  Created by Sergey Vasilenko on 20.09.2020.
//  Copyright © 2020 kudrykun. All rights reserved.
//

import Foundation

class GroupsParser {
    static func getGroups() -> [Group] {
        var groups = [Group]()
        let fullFilename = "demo-item-groups"

        guard let url = Bundle.main.url(forResource: fullFilename, withExtension: "json") else { return groups }

        do {
            let data = try Data(contentsOf: url)
            guard let groupsArray = try JSONSerialization.jsonObject(with: data, options: []) as? [Any] else { return groups }
            for groupJSON in groupsArray {
                guard let groupJSON = groupJSON as? [String: Any] else { continue }
                guard let group = parseGroup(from: groupJSON) else { continue }
                groups.append(group)
            }
            var items = ItemParser.getItems()
            arrangeGroupsAndItems(groups, items)
        } catch {
            print(error)
        }
        return groups
    }

    private static func parseGroup(from dict: [String: Any]) -> Group? {

        guard let type = dict["type"] as? String else { return nil }
        guard let name = dict["name"] as? String else { return nil }
        guard let order = dict["order"] as? String else { return nil }
        let groupName = dict["group"] as? String
        let icon = dict["icon"] as? String
        let isGlobalGroup = name == "logistics" || name == "production" || name == "combat" || name == "intermediate-products"

        let group = Group(type: type, name: name, order: order, group: groupName, icon: icon, isGlobalGroup: isGlobalGroup)

        return group
    }

    private static func arrangeGroupsAndItems(_ groups: [Group], _ items: [Item]) -> [ String : Group ] {
        var globalGroups: [String : Group] = [:]
        for group in groups.filter({ $0.isGlobalGroup }) {
            globalGroups[group.name] = group
        }
        var subgroups = groups.filter { !$0.isGlobalGroup }

        for subgroup in subgroups {
            guard let groupName = subgroup.group else { continue }
            globalGroups[groupName]?.subgroups[subgroup.name] = subgroup
        }

        for item in items {
            guard let groupName = (subgroups.first{$0.name == item.subgroup})?.group else { continue }
            globalGroups[groupName]?.subgroups[item.subgroup]?.items.append(item)
        }

        return globalGroups
    }
}
