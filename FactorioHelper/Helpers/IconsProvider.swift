//
//  IconsProvider.swift
//  FactorioHelper
//
//  Created by Sergey Vasilenko on 04.09.2020.
//  Copyright © 2020 kudrykun. All rights reserved.
//

import UIKit

class IconProvider {
    static func getImage(for recipeName: String) -> UIImage? {
        guard let sourceImage = UIImage(named: recipeName) else {
            print("There is no image for \"\(recipeName)\"")
            return nil
        }
        guard let croppedImage = crop(sourceImage) else { return nil }
        return croppedImage
    }

    private static func crop(_ image: UIImage) -> UIImage? {
        let cgImage = image.cgImage
        let croppingRect = CGRect(x: 0, y: 0, width: 64, height: 64)
        guard let croppedImage = cgImage?.cropping(to: croppingRect) else {
            print("CroppingFailed")
            return nil
        }
        let uiImage = UIImage(cgImage: croppedImage)
        return uiImage
    }

    static func getImage(for machineType: MachineType) -> UIImage? {
        var sourceImage: UIImage?

        switch machineType {
        case .Machine1:
            sourceImage = UIImage(named: "assembling-machine-1")
        case .Machine2:
            sourceImage = UIImage(named: "assembling-machine-2")
        case .Machine3:
            sourceImage = UIImage(named: "assembling-machine-3")
        case .OilRefinery:
            sourceImage = UIImage(named: "oil-refinery")
        case .ChemicalPlant:
            sourceImage = UIImage(named: "chemical-plant")
        case .Centrifuge:
            sourceImage = UIImage(named: "centrifuge")
        case .StoneFurnace:
            sourceImage = UIImage(named: "stone-furnace")
        case .SteelFurnace:
            sourceImage = UIImage(named: "steel-furnace")
        case .ElectricFurnace:
            sourceImage = UIImage(named: "electric-furnace")
        }

        guard let image = sourceImage, let croppedImage = crop(image) else { return nil }
        return croppedImage
    }
}
