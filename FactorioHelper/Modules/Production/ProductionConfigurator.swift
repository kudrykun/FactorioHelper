//
//  ProductionConfigurator.swift
//  FactorioHelper
//
//  Created by Sergey Vasilenko on 26.11.2020.
//  Copyright © 2020 kudrykun. All rights reserved.
//

import Foundation

class ProductionConfigurator: ProductionConfiguratorProtocol {
    func configure(with viewController: ProductionViewController, recipe: Recipe) {
        let presenter = ProductionPresenter()
        presenter.recipe = recipe
        presenter.view = viewController
        viewController.presenter = presenter

        let interactor = ProductionInteractor()
        interactor.presenter = presenter
        presenter.interactor = interactor

        let router = ProductionRouter()
        router.view = viewController
        presenter.router = router
    }

}
