//
//  AboutInteractor.swift
//  FactorioHelper
//
//  Created by Sergey Vasilenko on 29.11.2020.
//  Copyright © 2020 kudrykun. All rights reserved.
//

import UIKit

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

    func getFeedbackInfo() {
        guard let config = getConfig() else { return }
        guard let appName = config["App Name"] else { return }
        guard let appVersion = config["App Version"] else { return }
        guard let email = config["Support Email"] else { return }
        let iosVersion = UIDevice.current.systemName + " " + UIDevice.current.systemVersion
        let device = machineName()
        presenter?.interactor(self, didLoadFeedbackInfo: email, appName: appName, appVersion: appVersion, device: device, iosVersion: iosVersion)
    }

    private func getConfig() -> [String : String]? {
        if let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
           let xml = FileManager.default.contents(atPath: path) {
            return (try? PropertyListSerialization.propertyList(from: xml, options: .mutableContainersAndLeaves, format: nil)) as? [String : String]
        }
        return nil
    }

    // https://stackoverflow.com/questions/26028918/how-to-determine-the-current-iphone-device-model
    func machineName() -> String {
      var systemInfo = utsname()
      uname(&systemInfo)
      let machineMirror = Mirror(reflecting: systemInfo.machine)
      return machineMirror.children.reduce("") { identifier, element in
        guard let value = element.value as? Int8, value != 0 else { return identifier }
        return identifier + String(UnicodeScalar(UInt8(value)))
      }
    }
}
