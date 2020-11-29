//
//  MenuPresenter.swift
//  FactorioHelper
//
//  Created by Sergey Vasilenko on 29.11.2020.
//  Copyright © 2020 kudrykun. All rights reserved.
//

import Foundation

class MenuPresenter {
    weak var view: MenuViewControllerInput?
    var interactor: MenuInteractorInput?
    var router: MenuRouterProtocol?

}

extension MenuPresenter: MenuViewControllerOuput {
    func viewDidTapAboutCell(_ view: MenuViewControllerInput) {
        router?.openAbout()
    }

}

extension MenuPresenter: MenuInteractorOutput {

}
