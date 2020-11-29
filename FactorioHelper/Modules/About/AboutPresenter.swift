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
    func viewDidLoad(_ view: AboutViewControllerInput) {
        interactor?.getAppName()
    }

}

extension AboutPresenter: AboutInteractorOutput {
    func interactor(_ interactor: AboutInteractorInput, didLoadAppName appName: String) {
        view?.setAppName(appName)
        interactor.getAppVersion()
    }

    func interactor(_ interactor: AboutInteractorInput, didLoadAppVersion appVersion: String) {
        view?.setAppVersionNumber(appVersion)
        view?.reload()
    }


}
