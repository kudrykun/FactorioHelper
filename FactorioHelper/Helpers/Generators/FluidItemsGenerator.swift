//
//  FluidItemsGenerator.swift
//  FactorioHelper
//
//  Created by Sergey Vasilenko on 07.10.2020.
//  Copyright © 2020 kudrykun. All rights reserved.
//

import Foundation

public class FluidItemsGenerator {
    public static func generateFillBarrelItems(from fluids: [Fluid]) -> [Item] {
        return fluids.filter{$0.autoBarrel}.map{generateFillBarrelItem(from:$0)}
    }

    private static func generateFillBarrelItem(from fluid: Fluid) -> Item {
        let item = Item(type: "item", name: "\(fluid.name)-fill-barrel", subgroup: "fill-barrel", order: fluid.oder, icon: fluid.icon, baseColor: fluid.baseColor, flowColor: fluid.flowColor)
        return item
    }

    public static func generateEmptyBarrelItems(from fluids: [Fluid]) -> [Item] {
        return fluids.filter{$0.autoBarrel}.map{generateEmptyBarrelItem(from:$0)}
    }

    private static func generateEmptyBarrelItem(from fluid: Fluid) -> Item {
        let item = Item(type: "item", name: "\(fluid.name)-empty-barrel", subgroup: "empty-barrel", order: fluid.oder, icon: fluid.icon, baseColor: fluid.baseColor, flowColor: fluid.flowColor)
        return item
    }
}
