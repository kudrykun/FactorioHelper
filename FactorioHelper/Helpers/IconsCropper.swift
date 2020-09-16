//
//  IconsCropper.swift
//  FactorioHelper
//
//  Created by Sergey Vasilenko on 04.09.2020.
//  Copyright © 2020 kudrykun. All rights reserved.
//

import UIKit

class IconsCropper {
    static func crop(_ image: UIImage) -> UIImage? {
        let cgImage = image.cgImage
        let croppingRect = CGRect(x: 0, y: 0, width: 64, height: 64)
        guard let croppedImage = cgImage?.cropping(to: croppingRect) else {
            print("CroppingFailed")
            return nil
        }
        let uiImage = UIImage(cgImage: croppedImage)
        return uiImage
    }
}
