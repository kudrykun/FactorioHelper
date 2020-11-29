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

    private let tableView: UITableView = {
        let tableView = UITableView()
        let blackView = UIView()
        blackView.backgroundColor = Colors.commonBackgroundColor
        tableView.backgroundView = blackView
        return tableView
    }()

    enum TableSection: Int, CaseIterable {
        case header = 0
        case menu
        case note

        var sectionTitle: String? {
            return (self == .note) ? NSLocalizedString("note", comment: "") : nil
        }
    }

    enum MenuCell: Int, CaseIterable {
        case feedback = 0
        case shareApp
        case showOtherApps

        //можно заменить текст иконками, прям скопировать и вставить из sf symbols
        var iconName: String {
            switch self {
            case .feedback:
                return "envelope.badge"
            case .shareApp:
                return "square.and.arrow.up"
            case .showOtherApps:
                return "apps.iphone"
            }
        }

        var text: String {
            switch self {
            case .feedback:
                return NSLocalizedString("feedback", comment: "")
            case .shareApp:
                return NSLocalizedString("share app", comment: "")
            case .showOtherApps:
                return NSLocalizedString("show other apps", comment: "")
            }
        }
    }

    private var appName: String?
    private var appVersion: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        setupTableView()
        makeConstraints()
        presenter?.viewDidLoad(self)
    }

    func makeConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = NSLocalizedString("about", comment: "")
    }

}

extension AboutViewController: AboutViewControllerInput {
    func setAppVersionNumber(_ appVesrion: String) {
        self.appVersion = appVesrion
    }

    func setAppName(_ appName: String) {
        self.appName = appName
    }

    func reload() {
        tableView.reloadData()
    }


}

extension AboutViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return TableSection(rawValue: section)?.sectionTitle
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return TableSection.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tableSection = TableSection(rawValue: section) {
            switch tableSection {
            case .header:
                return 1
            case .menu:
                return MenuCell.allCases.count
            case .note:
                return 1
            }
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        //TODO TECH мрак
        if let tableSection = TableSection(rawValue: indexPath.section) {
            switch tableSection {
            case .header:
                let cell = HeaderCell()
                cell.appName = appName
                cell.appVersion = appVersion
                return cell
            case .menu:
                if let menuCell = MenuCell(rawValue: indexPath.row) {
                    return setupCell(with: menuCell)
                }
                return UITableViewCell()
            case .note:
                return NoteCell()
            }
        }
        return UITableViewCell()

    }

    func setupCell(with menuCell: MenuCell) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.imageView?.image = UIImage(systemName: menuCell.iconName)?.withTintColor(Colors.commonTextColor, renderingMode: .alwaysOriginal)
        cell.textLabel?.text = menuCell.text
        cell.backgroundColor = Colors.menuCellColor
        cell.textLabel?.textColor = Colors.commonTextColor
        cell.selectionStyle = .none
        return cell
    }
}

extension AboutViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UITableViewHeaderFooterView()
        view.tintColor = Colors.segmentedControlBackgroundColor
        view.textLabel?.textColor = Colors.commonTextColor
        return view
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard section != 0 else { return 0 }
        return UITableView.automaticDimension
    }
}
