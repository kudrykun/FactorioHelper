//
//  MainPresenter.swift
//  FactorioHelper
//
//  Created by Sergey Vasilenko on 26.11.2020.
//  Copyright © 2020 kudrykun. All rights reserved.
//

import Foundation

class MainPresenter {
    weak var view: MainViewControllerInput?
    var interactor: MainInteractorInput?
    var router: MainRouterProtocol?

}

extension MainPresenter: MainViewControllerOuput {
    func viewDidLoad(_ view: MainViewControllerInput) {
        interactor?.getGroups()
    }

    func view(_ view: MainViewControllerInput, didSelectCellWith recipe: Recipe) {
        router?.openProductionViewController(with: recipe)
    }

    func viewDidPressMenuButton(_ view: MainViewControllerInput) {
        router?.openMenu()
    }

}

extension MainPresenter: MainInteractorOutput {
    func interactor(_ interactor: MainInteractorInput, didLoadGroups groups: [String : Group]) {
        view?.setGroups(groups)
    }

}
