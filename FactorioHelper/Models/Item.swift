//
//  Item.swift
//  FactorioHelper
//
//  Created by Sergey Vasilenko on 20.09.2020.
//  Copyright © 2020 kudrykun. All rights reserved.
//

import UIKit

public struct Item {
    var type: String
    public var name: String
    var subgroup: String
    var order: String
    var icon: String?
    var baseColor: Color?
    var flowColor: Color?

    public var croppedIcon: UIImage? {
        if subgroup == "fill-barrel" {
            guard let range = name.range(of: "-fill-barrel") else { return nil }
            let fluidName = String(name[name.startIndex..<range.lowerBound])
            let fluid = FluidParser.parseFluids().filter{$0.name == fluidName}
            return IconsProvider.getFillBarrelIcon(for: fluid[0])
        } else if subgroup == "empty-barrel" {
            guard let range = name.range(of:"-empty-barrel") else { return nil }
            let fluidName = String(name[name.startIndex..<range.lowerBound])
            let fluid = FluidParser.parseFluids().filter{$0.name == fluidName}
            return IconsProvider.getEmptyBarrelIcon(for: fluid[0])
        } else {
            let iconNameSubstring = icon?.split(separator: "/").last ?? Substring(name)
            let iconName = String(iconNameSubstring)
            guard let sourceImage = UIImage(named: iconName) ?? UIImage(named: name) else { return nil }
            guard let croppedImage = IconsCropper.crop(sourceImage) else { return nil }
            return croppedImage
        }
    }
}
