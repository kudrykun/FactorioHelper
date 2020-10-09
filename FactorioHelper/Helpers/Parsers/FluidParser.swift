//
//  FluidParser.swift
//  FactorioHelper
//
//  Created by Sergey Vasilenko on 07.10.2020.
//  Copyright © 2020 kudrykun. All rights reserved.
//

import Foundation

class FluidParser {
    static let filenames = ["fluid", "demo-fluid"]

    static func parseFluids() -> [Fluid] {
        var fluids = [Fluid]()

        for filename in filenames {
            let fullFilename = filename + "JSONED"

            guard let url = Bundle.main.url(forResource: fullFilename, withExtension: "json") else { return fluids }

            do {
                let data = try Data(contentsOf: url)
                guard let fluidsArray = try JSONSerialization.jsonObject(with: data, options: []) as? [Any] else { return fluids }
                for fluidJSON in fluidsArray {
                    guard let fluidJSON = fluidJSON as? [String: Any] else { continue }
                    guard let fluid = parseFluid(from: fluidJSON) else { continue }
                    fluids.append(fluid)
                }
            } catch {
                print(error)
            }
        }

        return fluids
    }

    static func parseFluid(from dict: [String: Any]) -> Fluid? {
        guard let name = dict["name"] as? String else { return nil }

        guard let baseColor = parseColor(from: dict["base_color"] as? [String : Any]) else { return nil }
        guard let flowColor = parseColor(from: dict["flow_color"] as? [String : Any]) else { return nil }

        let icon = dict["icon"] as? String

        guard let order = dict["order"] as? String else { return nil }
        let autoBarrel = dict["auto_barrel"] as? Bool ?? true

        let fluid = Fluid(name: name, baseColor: baseColor, flowColor: flowColor, icon: icon, oder: order, autoBarrel: autoBarrel)

        return fluid
    }

    static func parseColor(from dict: [String : Any]?) -> Color? {
        guard let dict = dict else { return nil }
        let r = dict["r"] as! Double
        let g = dict["g"] as! Double
        let b = dict["b"] as! Double
        let a = dict["a"] as? Double
        return Color(r: r, g: g, b: b, a: a)
    }

}
