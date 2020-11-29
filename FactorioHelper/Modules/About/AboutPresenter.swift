//
//  AboutPresenter.swift
//  FactorioHelper
//
//  Created by Sergey Vasilenko on 29.11.2020.
//  Copyright © 2020 kudrykun. All rights reserved.
//

import Foundation

class AboutPresenter {
    weak var view: AboutViewControllerInput?
    var interactor: AboutInteractorInput?
    var router: AboutRouterProtocol?

}

extension AboutPresenter: AboutViewControllerOuput {

}

extension AboutPresenter: AboutInteractorOutput {

}
