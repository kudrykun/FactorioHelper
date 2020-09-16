//
//  SimpleRecipeCellModelGenerator.swift
//  FactorioHelper
//
//  Created by Sergey Vasilenko on 04.09.2020.
//  Copyright © 2020 kudrykun. All rights reserved.
//

import Foundation

class SimpleRecipeCellModelGenerator {
    static func generateModel(from recipe: Recipe) -> SimpleRecipeCellModel? {
        let title = recipe.name
        guard let image = recipe.croppedIcon else { return nil }
        return SimpleRecipeCellModel(image: image, title: title)
    }
}
