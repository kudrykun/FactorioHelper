//
//  AboutConfigurator.swift
//  FactorioHelper
//
//  Created by Sergey Vasilenko on 29.11.2020.
//  Copyright © 2020 kudrykun. All rights reserved.
//

import Foundation

class AboutConfigurator: AboutConfiguratorProtocol {
    func configure(with viewController: AboutViewController) {
        let presenter = AboutPresenter()
        presenter.view = viewController
        viewController.presenter = presenter

        let interactor = AboutInteractor()
        interactor.presenter = presenter
        presenter.interactor = interactor

        let router = AboutRouter()
        router.view = viewController
        presenter.router = router
    }

}
