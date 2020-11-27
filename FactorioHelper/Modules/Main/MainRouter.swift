//
//  MainRouter.swift
//  FactorioHelper
//
//  Created by Sergey Vasilenko on 26.11.2020.
//  Copyright © 2020 kudrykun. All rights reserved.
//

import UIKit

class MainRouter: MainRouterProtocol {
    weak var view: UIViewController?

    func openProductionViewController(with recipe: Recipe) {
        let viewController = ProductionViewController()
        viewController.configurator.configure(with: viewController, recipe: recipe)
        view?.navigationController?.pushViewController(viewController, animated: true)
    }

}
