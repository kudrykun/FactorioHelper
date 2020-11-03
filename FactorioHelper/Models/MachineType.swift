//
//  MachineType.swift
//  FactorioHelper
//
//  Created by Sergey Vasilenko on 16.09.2020.
//  Copyright © 2020 kudrykun. All rights reserved.
//

import UIKit

//не парсится, нужна проверка после обновления версии игры
public enum MachineType {
    case Machine1
    case Machine2
    case Machine3
    case OilRefinery
    case ChemicalPlant
    case Centrifuge
    case StoneFurnace
    case SteelFurnace
    case ElectricFurnace

    var speedMultipier: Double {
        switch self {
        case .Machine1: return 0.5
        case .Machine2: return 0.75
        case .Machine3: return 1.25
        case .OilRefinery: return 1.0
        case .ChemicalPlant: return 1.0
        case .Centrifuge: return 1.0
        case .StoneFurnace: return 1
        case .SteelFurnace: return 2
        case .ElectricFurnace: return 2
        }
    }

    var isLiquidEnabled: Bool {
        switch self {
        case .Machine1, .Centrifuge, .StoneFurnace, .SteelFurnace, .ElectricFurnace: return false
        case .Machine2, .Machine3, .OilRefinery, .ChemicalPlant: return true
        }
    }

    var modulesCount: Int {
        switch self {
        case .Machine1: return 0
        case .Machine2: return 2
        case .Machine3: return 4
        case .OilRefinery: return 3
        case .ChemicalPlant: return 3
        case .Centrifuge: return 2
        case .StoneFurnace: return 0
        case .SteelFurnace: return 0
        case .ElectricFurnace: return 2
        }
    }

    var minimalEnergyConsumption: Int {
        switch self {
        case .Machine1: return 2500
        case .Machine2: return 5000
        case .Machine3: return 12500
        case .OilRefinery: return 14000
        case .ChemicalPlant: return 7000
        case .Centrifuge: return 11670
        case .StoneFurnace: return 90000
        case .SteelFurnace: return 90000
        case .ElectricFurnace: return 6000
        }
    }

    var maximumEnergyConsumption: Int {
        switch self {
        case .Machine1: return 77500
        case .Machine2: return 15500
        case .Machine3: return 388000
        case .OilRefinery: return 434000
        case .ChemicalPlant: return 217000
        case .Centrifuge: return 362000
        case .StoneFurnace: return 90000
        case .SteelFurnace: return 90000
        case .ElectricFurnace: return 186000
        }
    }

    var icon: UIImage {
        guard let image = UIImage(named: name),
            let croppedImage = IconsCropper.crop(image) else { return UIImage() }
        return croppedImage
    }

    var name: String {
        switch self {
        case .Machine1: return "assembling-machine-1"
        case .Machine2: return "assembling-machine-2"
        case .Machine3: return "assembling-machine-3"
        case .OilRefinery: return "oil-refinery"
        case .ChemicalPlant: return "chemical-plant"
        case .Centrifuge: return "centrifuge"
        case .StoneFurnace: return "stone-furnace"
        case .SteelFurnace: return "steel-furnace"
        case .ElectricFurnace: return "electric-furnace"
        }
    }

    var localizedName: String {
        return NSLocalizedString(name, comment: "")
    }
}
