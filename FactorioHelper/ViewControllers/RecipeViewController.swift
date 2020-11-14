//
//  RecipeViewController.swift
//  FactorioHelper
//
//  Created by Sergey Vasilenko on 05.09.2020.
//  Copyright © 2020 kudrykun. All rights reserved.
//

import UIKit
import SnapKit

class RecipeViewController: UIViewController {

    var model: Recipe? {
        didSet {
            guard let recipe = model else { return }
            self.ingredients = recipe.baseIngredients
            self.headerView.model = recipe
        }
    }

    var ingredients = [Ingredient]()
    var productionItem: TreeNode<ProductionItem>? {
        didSet {
            reloadFlattened()
        }
    }
    func reloadFlattened() {
        flattenedItems = productionItem?.flattened() ?? []
    }
    
    var flattenedItems: [TreeNode<ProductionItem>] = []
    var itemsPerSecond: Double = 1

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
        guard let recipe = model else { return }
        productionItem = ProductionCalculator.getProductionItem(for: recipe, countPerSecond: 1, nestingLevel: 0)
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
            guard let time = Double(timeString) else { return }
            guard let recipe = self?.model else { return }
            self?.productionItem = ProductionCalculator.getProductionItem(for: recipe, countPerSecond: time, nestingLevel: 0)
            self?.itemsPerSecond = time
            self?.productionTableView.reloadData()
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
}

extension RecipeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {


        let model = flattenedItems[indexPath.row]
        return model.value.collapsed ? 0 : 62
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? ProductionItemCell else { return }
//        var indexPathCopy = indexPath

        guard let collapsedDescendants = cell.model?.value.collapsedDescendants else { return }
        if collapsedDescendants {
            cell.model?.value.collapsedDescendants = false
            cell.model?.traverseTree(wtih: { child in
                child.value.collapsed = false
            })
            cell.model?.value.collapsed = false
        } else {
            cell.model?.value.collapsedDescendants = true
            cell.model?.traverseTree(wtih: { child in
                child.value.collapsed = true
            })
            cell.model?.value.collapsed = false
        }

//        cell.model?.value.collapsedDescendants = !(cell.model?.value.collapsedDescendants ?? true)
//        cell.model?.traverseTree(wtih: { child in
//            child.value.collapsed = !child.value.collapsed
//        })
//        cell.model?.value.collapsed = !(cell.model?.value.collapsed ?? true)

        reloadFlattened()
        tableView.reloadData()
    }
}

extension RecipeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flattenedItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProductionItemCell", for: indexPath) as? ProductionItemCell else { return UITableViewCell() }
        cell.model = flattenedItems[indexPath.row]
        cell.accessibilityIdentifier = flattenedItems[indexPath.row].value.name
        cell.didSelectMachine = {
            guard let model = self.productionItem else { return }
            self.productionItem = ProductionCalculator.getRecalculatedProductionItem(item: model, countPerSecond: self.itemsPerSecond)
            self.productionTableView.reloadData()
        }
        cell.isHidden = flattenedItems[indexPath.row].value.collapsed
//        print("reload cell. isCollapsed: \(model?.c)")
        return cell
    }


}
