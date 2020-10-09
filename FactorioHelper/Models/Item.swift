//
//  Item.swift
//  FactorioHelper
//
//  Created by Sergey Vasilenko on 20.09.2020.
//  Copyright © 2020 kudrykun. All rights reserved.
//

import UIKit

struct Item {
    var type: String
    var name: String
    var subgroup: String
    var order: String
    var icon: String?
    var baseColor: Color?
    var flowColor: Color?

    var croppedIcon: UIImage? {
        if subgroup == "fill-barrel" {
            guard let barrelNotCropped = UIImage(named: "barrel-fill") else { return nil}
            guard let topMaskNotCropped = UIImage(named: "barrel-fill-top-mask") else { return nil}
            guard let sideMaskNotCropped = UIImage(named: "barrel-fill-side-mask") else { return nil}
            guard let dropNotCropped = UIImage(named: name) else { return nil}


            guard let barrel = IconsCropper.crop(barrelNotCropped) else { return nil }
            guard let topMask = IconsCropper.crop(topMaskNotCropped)?.withTintColor(flowColor?.uiColor ?? UIColor.white, renderingMode: .alwaysTemplate) else { return nil }
            guard let sideMask = IconsCropper.crop(sideMaskNotCropped)?.withTintColor(baseColor?.uiColor ?? UIColor.white, renderingMode: .alwaysOriginal) else { return nil }
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

        } else if subgroup == "empty-barrel" {
            //?.withTintColor(baseColor?.uiColor ?? UIColor.white)

            guard let barrelNotCropped = UIImage(named: "barrel-empty") else { return nil}
            guard let topMaskNotCropped = UIImage(named: "barrel-empty-top-mask") else { return nil}
            guard let sideMaskNotCropped = UIImage(named: "barrel-empty-side-mask") else { return nil}
            guard let dropNotCropped = UIImage(named: name) else { return nil}


            guard let barrel = IconsCropper.crop(barrelNotCropped) else { return nil }
            guard let topMask = IconsCropper.crop(topMaskNotCropped)?.withTintColor(flowColor?.uiColor ?? UIColor.white, renderingMode: .alwaysTemplate) else { return nil }
            guard let sideMask = IconsCropper.crop(sideMaskNotCropped)?.withTintColor(baseColor?.uiColor ?? UIColor.white, renderingMode: .alwaysOriginal) else { return nil }
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

        } else {
            guard let iconNameSubstring = icon?.split(separator: "/").last else { return nil }
            let iconName = String(iconNameSubstring)
            guard let sourceImage = UIImage(named: iconName) else { return nil }
            guard let croppedImage = IconsCropper.crop(sourceImage) else { return nil }
            return croppedImage
        }

        return UIImage()
    }
}
