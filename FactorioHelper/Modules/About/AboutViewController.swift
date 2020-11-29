//
//  AboutViewController.swift
//  FactorioHelper
//
//  Created by Sergey Vasilenko on 29.11.2020.
//  Copyright © 2020 kudrykun. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    var presenter: AboutViewControllerOuput?
    let configurator = AboutConfigurator()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = NSLocalizedString("about", comment: "")
    }

}

extension AboutViewController: AboutViewControllerInput {

}
