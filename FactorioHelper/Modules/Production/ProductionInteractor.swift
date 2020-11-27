//
//  ProductionInteractor.swift
//  FactorioHelper
//
//  Created by Sergey Vasilenko on 26.11.2020.
//  Copyright © 2020 kudrykun. All rights reserved.
//

import Foundation

class ProductionInteractor {
    weak var presenter: ProductionInteractorOutput?
}

extension ProductionInteractor: ProductionInteractorInput {
    func getProductionItem(for recipe: Recipe) {
        guard let productionItem = ProductionCalculator.getProductionItem(for: recipe, countPerSecond: 1, nestingLevel: 0) else { return }
        presenter?.interactor(self, didLoadProductionItem: productionItem)
    }

    func getUsedMachinesList(for productionitem: TreeNode<ProductionItem>) {
        let machinesList = ProductionCalculator.getMachinesCountSet(for: productionitem)
        presenter?.interactor(self, didLoadUsedMachinesList: machinesList)
    }

    func getRecalculatedProductionItem(for item: TreeNode<ProductionItem>, countPerSecond: Double) {
        let productionItem = ProductionCalculator.getRecalculatedProductionItem(item: item, countPerSecond: countPerSecond)
        presenter?.interactor(self, didLoadProductionItem: productionItem)
    }

}
