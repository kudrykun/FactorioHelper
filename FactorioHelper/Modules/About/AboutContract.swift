//
//  AboutContract.swift
//  FactorioHelper
//
//  Created by Sergey Vasilenko on 29.11.2020.
//  Copyright © 2020 kudrykun. All rights reserved.
//

import Foundation

protocol AboutConfiguratorProtocol: class {

}

protocol AboutViewControllerOuput: class {
    func viewDidLoad(_ view: AboutViewControllerInput)
    func viewDidPressFeedback(_ view: AboutViewControllerInput)
}

protocol AboutViewControllerInput: class {
    func setAppVersionNumber(_ appVersion: String)
    func setAppName(_ appName: String)
    func reload()
}

protocol AboutInteractorInput: class {
    func getAppName()
    func getAppVersion()
    func getFeedbackInfo()
}

protocol AboutInteractorOutput: class {
    func interactor(_ interactor: AboutInteractorInput, didLoadAppName appName: String)
    func interactor(_ interactor: AboutInteractorInput, didLoadAppVersion appVersion: String)
    func interactor(_ interactor: AboutInteractorInput, didLoadFeedbackInfo email: String, appName: String, appVersion: String, device: String, iosVersion: String)
}

protocol AboutRouterProtocol: class {
    func openFeedbackMail(to email: String, subject: String, text: String)
}
