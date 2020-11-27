//
//  MainConfigurator.swift
//  FactorioHelper
//
//  Created by Sergey Vasilenko on 26.11.2020.
//  Copyright © 2020 kudrykun. All rights reserved.
//

import Foundation

class MainConfigurator: MainConfiguratorProtocol {
    func configure(with viewController: MainViewController) {
        let presenter = MainPresenter()
        presenter.view = viewController
        viewController.presenter = presenter

        let interactor = MainInteractor()
        interactor.presenter = presenter
        presenter.interactor = interactor

        let router = MainRouter()
        router.view = viewController
        presenter.router = router
    }
}
