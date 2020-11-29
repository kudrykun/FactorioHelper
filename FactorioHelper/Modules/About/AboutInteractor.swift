//
//  AboutInteractor.swift
//  FactorioHelper
//
//  Created by Sergey Vasilenko on 29.11.2020.
//  Copyright © 2020 kudrykun. All rights reserved.
//

import Foundation

class AboutInteractor {
    weak var presenter: AboutInteractorOutput?
}

extension AboutInteractor: AboutInteractorInput {
    func getAppName() {
        guard let config = getConfig() else { return }
        guard let appName = config["App Name"] else { return }
        presenter?.interactor(self, didLoadAppName: appName)
    }

    func getAppVersion() {
        guard let config = getConfig() else { return }
        guard let appVersion = config["App Version"] else { return }
        presenter?.interactor(self, didLoadAppVersion: appVersion)
    }

    private func getConfig() -> [String : String]? {
        if let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
           let xml = FileManager.default.contents(atPath: path) {
            return (try? PropertyListSerialization.propertyList(from: xml, options: .mutableContainersAndLeaves, format: nil)) as? [String : String]
        }
        return nil
    }
}
