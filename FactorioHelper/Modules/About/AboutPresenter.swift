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

    func viewDidPressFeedback(_ view: AboutViewControllerInput) {
        interactor?.getFeedbackInfo()
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

    func interactor(_ interactor: AboutInteractorInput, didLoadFeedbackInfo email: String, appName: String, appVersion: String, device: String, iosVersion: String) {

        let message = """
        \n\n\(NSLocalizedString("versionMessage", comment: "")) \(appVersion)
        \(device)
        \(iosVersion)
        """

        router?.openFeedbackMail(to: email, subject: appName, text: message)
    }

}
