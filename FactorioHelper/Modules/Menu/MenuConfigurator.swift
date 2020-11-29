//
//  MenuConfigurator.swift
//  FactorioHelper
//
//  Created by Sergey Vasilenko on 29.11.2020.
//  Copyright © 2020 kudrykun. All rights reserved.
//

import Foundation

class MenuConfigurator: MenuConfiguratorProtocol {
    func configure(with viewController: MenuViewController) {
        let presenter = MenuPresenter()
        presenter.view = viewController
        viewController.presenter = presenter

        let interactor = MenuInteractor()
        interactor.presenter = presenter
        presenter.interactor = interactor

        let router = MenuRouter()
        router.view = viewController
        presenter.router = router
    }

}
