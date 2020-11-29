//
//  MenuViewController.swift
//  FactorioHelper
//
//  Created by Sergey Vasilenko on 29.11.2020.
//  Copyright © 2020 kudrykun. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    var presenter: MenuViewControllerOuput?
    let configurator = MenuConfigurator()

    private let tableView: UITableView = {
        let tableView = UITableView()

        let blackView = UIView()
        blackView.backgroundColor = Colors.commonBackgroundColor
        tableView.backgroundView = blackView

        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tableView)

        makeConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigation()
    }

    func setupNavigation() {
        navigationItem.title = NSLocalizedString("Menu", comment: "")

        let textAttributes = [NSAttributedString.Key.foregroundColor:Colors.commonTextColor]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }

    func makeConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension MenuViewController: MenuViewControllerInput {

}
