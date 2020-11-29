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
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()

        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tableView)

        makeConstraints()
        setupTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigation()
    }

    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }

    func setupNavigation() {
        navigationItem.title = NSLocalizedString("Menu", comment: "")
    }

    func makeConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension MenuViewController: MenuViewControllerInput {

}

extension MenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = UITableViewCell()
            cell.imageView?.image = UIImage(systemName: "info.circle")?.withTintColor(Colors.commonTextColor, renderingMode: .alwaysOriginal)
            cell.textLabel?.text = NSLocalizedString("about", comment: "")
            cell.backgroundColor = Colors.menuCellColor
            cell.textLabel?.textColor = Colors.commonTextColor
            cell.selectionStyle = .none
            return cell
        default:
            return UITableViewCell()
        }
    }

}

extension MenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            presenter?.viewDidTapAboutCell(self)
        default:
            return
        }
    }
}

