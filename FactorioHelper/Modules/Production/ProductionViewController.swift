//
//  ProductionViewController.swift
//  FactorioHelper
//
//  Created by Sergey Vasilenko on 26.11.2020.
//  Copyright © 2020 kudrykun. All rights reserved.
//

import UIKit

class ProductionViewController: UIViewController {

    var presenter: ProductionViewControllerOuput?
    let configurator = ProductionConfigurator()

    private var recipe: Recipe?
    var productionItem: TreeNode<ProductionItem>?

    var flattenedItems: [TreeNode<ProductionItem>] = []
    var itemsPerSecond: Double = 1
    var neededMachinesList: [MachinesSet] = []

    private let headerView: RecipeDescriptionHeaderView = {
        let view = RecipeDescriptionHeaderView()
        return view
    }()

    private let timeSelectionView: TimeSelectionView = {
        let view = TimeSelectionView()
        return view
    }()

    private let productionTableView: UITableView = {
        let tableView = UITableView()
        tableView.estimatedRowHeight = 0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.allowsSelection = true
        tableView.isMultipleTouchEnabled = true
        tableView.accessibilityIdentifier = "productionTableView"
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        presenter?.viewDidLoad(self)
    }

    private func setupView() {
        view.backgroundColor = Colors.commonBackgroundColor
        setupHeaderView()
        setupTimeSelectionView()
        setupTableView()
    }

    private func setupHeaderView() {
        view.addSubview(headerView)
        setupHeaderViewConstraints()
    }

    private func setupTimeSelectionView() {
        view.addSubview(timeSelectionView)

        timeSelectionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
            make.top.equalTo(headerView.snp.bottom)
        }

        timeSelectionView.secondsTextFieldChanged = { [weak self] timeString in
            guard let self = self else { return }
            guard let time = Double(timeString) else { return }
            guard let productionItem = self.productionItem else { return }
            self.itemsPerSecond = time

            self.presenter?.view(self, needUpdateProductionItemFor: productionItem, countPerSecond: time)
        }
    }

    private func setupTableView() {
        view.addSubview(productionTableView)
        productionTableView.snp.makeConstraints { make in
            make.top.equalTo(timeSelectionView.snp.bottom).offset(15)
            make.left.right.bottom.equalToSuperview()
        }
        productionTableView.dataSource = self
        productionTableView.delegate = self

        productionTableView.register(ProductionItemCell.self, forCellReuseIdentifier: "ProductionItemCell")
        productionTableView.register(SummaryCellTableViewCell.self, forCellReuseIdentifier: "SummaryCellTableViewCell")
        productionTableView.rowHeight = 250

        let blackView = UIView()
        blackView.backgroundColor = Colors.commonBackgroundColor
        productionTableView.backgroundView = blackView
    }

    private func setupHeaderViewConstraints() {
        headerView.snp.makeConstraints { make in
            make.height.equalTo(100)
            make.left.right.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
    }

    func reloadFlattened() {
        flattenedItems = productionItem?.flattened() ?? []
    }
}

extension ProductionViewController: ProductionViewControllerInput {
    func update(recipe: Recipe) {
        self.recipe = recipe
        self.headerView.model = recipe
    }

    func update(productionItem item: TreeNode<ProductionItem>) {
        self.productionItem = item
        self.presenter?.view(self, needUpdateUsedMachinesFor: item)
        reloadFlattened()
        self.productionTableView.reloadData()
    }

    func update(usedMachinesList: [MachinesSet]) {
        self.neededMachinesList = usedMachinesList
    }
}

extension ProductionViewController: UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        switch indexPath.section {
        case 0:
            return 62
        case 1:
            let model = flattenedItems[indexPath.row]
            return model.value.collapsed ? 0 : 62
        default:
            return 0
        }

    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section != 0 else { return }
        guard let cell = tableView.cellForRow(at: indexPath) as? ProductionItemCell else { return }
        guard let isExpandingAction = cell.model?.value.collapsedDescendants else { return }

        cell.model?.value.collapsedDescendants = !isExpandingAction
        cell.model?.traverseTree(wtih: { child in
            child.value.collapsed = !isExpandingAction
        }, proceed: { item in
            guard item != cell.model else { return true }
            if item.value.collapsedDescendants {
                return false
            } else {
                return true
            }
        })
        cell.model?.value.collapsed = false

        reloadFlattened()
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UITableViewHeaderFooterView()
        view.tintColor = Colors.segmentedControlBackgroundColor
        view.textLabel?.textColor = Colors.commonTextColor
        return view
    }
}

extension ProductionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return NSLocalizedString("summary", comment: "")
        case 1:
            return NSLocalizedString("description", comment: "")
        default:
            return nil
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return neededMachinesList.count
        case 1:
            return flattenedItems.count
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SummaryCellTableViewCell", for: indexPath) as? SummaryCellTableViewCell else { return UITableViewCell() }
            cell.machineType = self.neededMachinesList[indexPath.row].type
            cell.machinesCount = self.neededMachinesList[indexPath.row].count
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProductionItemCell", for: indexPath) as? ProductionItemCell else { return UITableViewCell() }
            cell.model = flattenedItems[indexPath.row]
            cell.accessibilityIdentifier = flattenedItems[indexPath.row].value.name
            cell.didSelectMachine = {
                guard let productionItem = self.productionItem else { return }
                self.presenter?.view(self, needUpdateProductionItemFor: productionItem, countPerSecond: self.itemsPerSecond)
            }
            cell.isHidden = flattenedItems[indexPath.row].value.collapsed
            return cell
        default:
            return UITableViewCell()
        }
    }
}
