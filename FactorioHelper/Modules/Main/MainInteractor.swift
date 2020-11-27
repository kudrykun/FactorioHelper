//
//  MainInteractor.swift
//  FactorioHelper
//
//  Created by Sergey Vasilenko on 26.11.2020.
//  Copyright © 2020 kudrykun. All rights reserved.
//

import Foundation

class MainInteractor {
    weak var presenter: MainInteractorOutput?
}

extension MainInteractor: MainInteractorInput {
    func getGroups() {
        let groups = GroupsParser.getGroups()
        presenter?.interactor(self, didLoadGroups: groups)
    }
}
