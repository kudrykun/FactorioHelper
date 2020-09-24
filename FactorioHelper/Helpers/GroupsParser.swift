//
//  GroupsParser.swift
//  FactorioHelper
//
//  Created by Sergey Vasilenko on 20.09.2020.
//  Copyright © 2020 kudrykun. All rights reserved.
//

import Foundation

class GroupsParser {
    static func getGroups() -> [String : Group] {
        var groups = [Group]()
        let fullFilename = "demo-item-groups"

        guard let url = Bundle.main.url(forResource: fullFilename, withExtension: "json") else { return [:] }

        do {
            let data = try Data(contentsOf: url)
            guard let groupsArray = try JSONSerialization.jsonObject(with: data, options: []) as? [Any] else { return [:] }
            for groupJSON in groupsArray {
                guard let groupJSON = groupJSON as? [String: Any] else { continue }
                guard let group = parseGroup(from: groupJSON) else { continue }
                groups.append(group)
            }
            let items = ItemParser.getItems()
            return arrangeGroupsAndItems(groups, items)
        } catch {
            print(error)
        }
        return [:]
    }

    private static func parseGroup(from dict: [String: Any]) -> Group? {

        guard let type = dict["type"] as? String else { return nil }
        guard let name = dict["name"] as? String else { return nil }
        guard let order = dict["order"] as? String else { return nil }
        let groupName = dict["group"] as? String
        var icon = dict["icon"] as? String
        let isGlobalGroup = name == "logistics" || name == "production" || name == "combat" || name == "intermediate-products"

        if let iconPath = icon {
            let subs = iconPath.split(separator: "/")
            icon = String(subs.last ?? "")
        }

        let group = Group(type: type, name: name, order: order, group: groupName, icon: icon, isGlobalGroup: isGlobalGroup)

        return group
    }

    private static func arrangeGroupsAndItems(_ groups: [Group], _ items: [Item]) -> [ String : Group ] {

        //формируем словарь глобальных групп
        var globalGroups: [String : Group] = [:]
        for group in groups.filter({ $0.isGlobalGroup }) {
            globalGroups[group.name] = group
        }

        //формируем словарь подгрупп
        var subgroups: [String : Group] = [:]
        for subgroup in groups.filter({ !$0.isGlobalGroup}) {
            subgroups[subgroup.name] = subgroup
        }

        //раскидываем итемы по подгруппам
        for item in items {
            subgroups[item.subgroup]?.items.append(item)
        }

        //сортируем итемы
        for subgroup in subgroups {
            subgroups[subgroup.value.name]?.items.sort { $0.order < $1.order }
        }

        //раскидываем подгруппы по группам
        for subgroup in subgroups {
            guard let groupName = subgroup.value.group else { continue }
            globalGroups[groupName]?.subgroups.append(subgroup.value)
        }

        //сортируем подгруппы
        for group in globalGroups {
            globalGroups[group.value.name]?.subgroups.sort { $0.order < $1.order }
        }

        return globalGroups
    }
}
