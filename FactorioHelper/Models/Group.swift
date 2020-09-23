//
//  Group.swift
//  FactorioHelper
//
//  Created by Sergey Vasilenko on 20.09.2020.
//  Copyright © 2020 kudrykun. All rights reserved.
//

import Foundation


struct Group {
    var type: String
    var name: String
    var order: String
    var group: String?
    var icon: String?
    var isGlobalGroup: Bool = false

    var subgroups: [Group] = []
    var items = [Item]()

    init(type: String, name: String, order: String, group: String?, icon: String?, isGlobalGroup: Bool) {
        self.type = type
        self.name = name
        self.order = order
        self.group = group
        self.icon = icon
        self.isGlobalGroup = isGlobalGroup
    }
}
