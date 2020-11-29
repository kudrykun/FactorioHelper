//
//  FactorioHelperNavigationController.swift
//  FactorioHelper
//
//  Created by Sergey Vasilenko on 29.11.2020.
//  Copyright © 2020 kudrykun. All rights reserved.
//

import UIKit

class FactorioHelperNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let textAttributes = [NSAttributedString.Key.foregroundColor:Colors.commonTextColor]
        navigationBar.titleTextAttributes = textAttributes
        navigationBar.barTintColor = Colors.commonBackgroundColor
        navigationBar.tintColor = Colors.commonTextColor
        navigationBar.barStyle = .black
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)

        var isMenuControllerInStack = false
        viewControllers.forEach { vc in
            isMenuControllerInStack = isMenuControllerInStack || (vc as? MenuViewController) != nil
        }
        guard !isMenuControllerInStack else { return }
        addMenuItem(to: viewController)
    }

    func addMenuItem(to viewController: UIViewController) {
        let menuButtonTitle = NSLocalizedString("menu", comment: "")
        let menuButton = UIBarButtonItem(title: menuButtonTitle, style: .plain, target: self, action: #selector(menuButtonTapped))
        viewController.navigationItem.rightBarButtonItem = menuButton
    }

    @objc func menuButtonTapped() {
        let viewController = MenuViewController()
        viewController.configurator.configure(with: viewController)
        pushViewController(viewController, animated: true)
    }
}
