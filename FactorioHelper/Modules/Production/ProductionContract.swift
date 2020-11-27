//
//  ProductionContract.swift
//  FactorioHelper
//
//  Created by Sergey Vasilenko on 26.11.2020.
//  Copyright © 2020 kudrykun. All rights reserved.
//

import Foundation

protocol ProductionConfiguratorProtocol: class {

}

protocol ProductionViewControllerOuput: class {
    func viewDidLoad(_ view: ProductionViewControllerInput)
    func view(_ view: ProductionViewControllerInput, needUpdateProductionItemFor item: TreeNode<ProductionItem>, countPerSecond: Double)
    func view(_ view: ProductionViewControllerInput, needUpdateUsedMachinesFor productionItem: TreeNode<ProductionItem>)
}

protocol ProductionViewControllerInput: class {
    func update(productionItem item: TreeNode<ProductionItem>)
    func update(recipe: Recipe)
    func update(usedMachinesList: [MachinesSet])
}

protocol ProductionInteractorInput: class {
    func getProductionItem(for recipe: Recipe)
    func getRecalculatedProductionItem(for item: TreeNode<ProductionItem>, countPerSecond: Double)
    func getUsedMachinesList(for productionitem: TreeNode<ProductionItem>)
}

protocol ProductionInteractorOutput: class {
    func interactor(_ interactor: ProductionInteractorInput, didLoadProductionItem item: TreeNode<ProductionItem>)
    func interactor(_ interactor: ProductionInteractorInput, didLoadUsedMachinesList list: [MachinesSet])
}

protocol ProductionRouterProtocol: class {

}
