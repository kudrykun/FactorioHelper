//
//  ProductionPresenter.swift
//  FactorioHelper
//
//  Created by Sergey Vasilenko on 26.11.2020.
//  Copyright © 2020 kudrykun. All rights reserved.
//

import Foundation

class ProductionPresenter {
    weak var view: ProductionViewControllerInput?
    var interactor: ProductionInteractorInput?
    var router: ProductionRouterProtocol?

    var recipe: Recipe?
}

extension ProductionPresenter: ProductionViewControllerOuput {
    func viewDidLoad(_ view: ProductionViewControllerInput) {
        guard let recipe = recipe else { return }
        interactor?.getProductionItem(for: recipe)
        view.update(recipe: recipe)
    }

    func view(_ view: ProductionViewControllerInput, needUpdateProductionItemFor item: TreeNode<ProductionItem>, countPerSecond: Double) {
        interactor?.getRecalculatedProductionItem(for: item, countPerSecond: countPerSecond)
    }

    func view(_ view: ProductionViewControllerInput, needUpdateUsedMachinesFor productionItem: TreeNode<ProductionItem>) {
        interactor?.getUsedMachinesList(for: productionItem)
    }

}

extension ProductionPresenter: ProductionInteractorOutput {
    func interactor(_ interactor: ProductionInteractorInput, didLoadProductionItem item: TreeNode<ProductionItem>) {
        view?.update(productionItem: item)
        interactor.getUsedMachinesList(for: item)
    }
    
    func interactor(_ interactor: ProductionInteractorInput, didLoadUsedMachinesList list: [MachinesSet]) {
        view?.update(usedMachinesList: list)
    }
}
