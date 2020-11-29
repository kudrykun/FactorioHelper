//
//  MenuRouter.swift
//  FactorioHelper
//
//  Created by Sergey Vasilenko on 29.11.2020.
//  Copyright © 2020 kudrykun. All rights reserved.
//

import UIKit

class MenuRouter: MenuRouterProtocol {
    weak var view: UIViewController?

    func openAbout() {
        let viewController = AboutViewController()
        viewController.configurator.configure(with: viewController)
        view?.navigationController?.pushViewController(viewController, animated: true)
    }

}
