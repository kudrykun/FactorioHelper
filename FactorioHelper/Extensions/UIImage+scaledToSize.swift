//
//  UIImage+scaledToSize.swift
//  FactorioHelper
//
//  Created by Sergey Vasilenko on 25.11.2020.
//  Copyright © 2020 kudrykun. All rights reserved.
//

import UIKit

extension UIImage {
    func scaledToSize(_ newSize: CGSize, position: CGPoint = .zero) -> UIImage{
        UIGraphicsBeginImageContext(newSize)
        self.draw(in: CGRect(x: position.x, y: position.y, width: newSize.width, height: newSize.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image?.withRenderingMode(.alwaysOriginal) ?? UIImage()
    }
}
