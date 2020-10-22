//
//  IconsProvider.swift
//  FactorioHelper
//
//  Created by Sergey Vasilenko on 22.10.2020.
//  Copyright © 2020 kudrykun. All rights reserved.
//

import UIKit

public class IconsProvider {
    public static func getFillBarrelIcon(for fluid: Fluid) -> UIImage? {
        guard let barrelNotCropped = UIImage(named: "barrel-fill") else { return nil}
        guard let topMaskNotCropped = UIImage(named: "barrel-fill-top-mask") else { return nil}
        guard let sideMaskNotCropped = UIImage(named: "barrel-fill-side-mask") else { return nil}
        guard let dropNotCropped = UIImage(named: fluid.name) else { return nil}


        guard let barrel = IconsCropper.crop(barrelNotCropped) else { return nil }
        guard let topMask = IconsCropper.crop(topMaskNotCropped)?.withTintColor(fluid.flowColor.uiColor, renderingMode: .alwaysTemplate) else { return nil }
        guard let sideMask = IconsCropper.crop(sideMaskNotCropped)?.withTintColor(fluid.baseColor.uiColor, renderingMode: .alwaysOriginal) else { return nil }
        guard let drop = IconsCropper.crop(dropNotCropped) else { return nil }

        let size = CGSize(width: 64, height: 64)
        UIGraphicsBeginImageContext(size)

        let areaSize = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        barrel.draw(in: areaSize)
        topMask.draw(in: areaSize, blendMode: .color, alpha: 0.5)
        sideMask.draw(in: areaSize, blendMode: .darken, alpha: 0.7)
        drop.draw(in: CGRect(x: 2, y: 2, width: 32, height: 32))

        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return newImage
    }

    public static func getEmptyBarrelIcon(for fluid: Fluid) -> UIImage? {

        guard let barrelNotCropped = UIImage(named: "barrel-empty") else { return nil}
        guard let topMaskNotCropped = UIImage(named: "barrel-empty-top-mask") else { return nil}
        guard let sideMaskNotCropped = UIImage(named: "barrel-empty-side-mask") else { return nil}
        guard let dropNotCropped = UIImage(named: fluid.name) else { return nil}


        guard let barrel = IconsCropper.crop(barrelNotCropped) else { return nil }
        guard let topMask = IconsCropper.crop(topMaskNotCropped)?.withTintColor(fluid.flowColor.uiColor, renderingMode: .alwaysTemplate) else { return nil }
        guard let sideMask = IconsCropper.crop(sideMaskNotCropped)?.withTintColor(fluid.baseColor.uiColor, renderingMode: .alwaysOriginal) else { return nil }
        guard let drop = IconsCropper.crop(dropNotCropped) else { return nil }

        let size = CGSize(width: 64, height: 64)
        UIGraphicsBeginImageContext(size)

        let areaSize = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        barrel.draw(in: areaSize)
        topMask.draw(in: areaSize, blendMode: .color, alpha: 0.5)
        sideMask.draw(in: areaSize, blendMode: .darken, alpha: 0.7)
        drop.draw(in: CGRect(x: 30, y: 32, width: 32, height: 32))

        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return newImage
    }
}
