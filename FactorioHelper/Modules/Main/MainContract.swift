//
//  MainContract.swift
//  FactorioHelper
//
//  Created by Sergey Vasilenko on 26.11.2020.
//  Copyright © 2020 kudrykun. All rights reserved.
//

import Foundation

protocol MainConfiguratorProtocol: class {

}

protocol MainViewControllerOuput: class {
    func viewDidLoad( _ view: MainViewControllerInput)
    func view(_ view: MainViewControllerInput, didSelectCellWith recipe: Recipe)
    func viewDidPressMenuButton(_ view: MainViewControllerInput)
}

protocol MainViewControllerInput: class {
    func setGroups(_ groups: [String : Group])
}

protocol MainInteractorInput: class {
    func getGroups()
}

protocol MainInteractorOutput: class {
    func interactor( _ interactor: MainInteractorInput, didLoadGroups groups: [String : Group])
}

protocol MainRouterProtocol: class {
    func openProductionViewController(with recipe: Recipe)
    func openMenu()
}
