//
//  ProductionItemCell.swift
//  FactorioHelper
//
//  Created by Sergey Vasilenko on 11.09.2020.
//  Copyright © 2020 kudrykun. All rights reserved.
//

import UIKit
import SnapKit

class ProductionItemCell: UITableViewCell {

    var nestingLevel: Int = 0 {
        didSet {
            descriptionViewOffsetConstraint?.update(offset: 15 + 15 * nestingLevel)
            leftTableViewOffsetConstraint?.update(offset: 15 * nestingLevel)
        }
    }
    var model: ProductionItem? {
        didSet {
            updateCell(with: model)
        }
    }

    private var descriptionBottomConstraint: Constraint?
    private var leftTableViewOffsetConstraint: Constraint?
    private var descriptionViewOffsetConstraint: Constraint?

    private let productionTableView: UITableView = {
        let tableView = UITableView()
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()

    private let productionDescriptionView: ProductionDescriptionView = {
        let view = ProductionDescriptionView()
        return view
    }()

    required init?(coder: NSCoder) {
        fatalError("init?(coder:) has not been implemented")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupConstraints()
        setupTableView()
        productionTableView.reloadData()
    }

    private func setupView() {
        addSubview(productionDescriptionView)
        addSubview(productionTableView)
        selectionStyle = .none
    }

    private func setupConstraints() {

        productionDescriptionView.snp.makeConstraints { make in
            descriptionViewOffsetConstraint = make.left.equalToSuperview().offset(15).constraint
            make.top.equalToSuperview().offset(15)
            make.right.equalToSuperview().inset(15)
            descriptionBottomConstraint = make.bottom.equalTo(productionTableView.snp.top).offset(-15).constraint
        }
        
        productionTableView.snp.makeConstraints { make in
            leftTableViewOffsetConstraint = make.left.equalToSuperview().constraint
            make.right.bottom.equalToSuperview()
        }
    }

    private func setupTableView() {
        productionTableView.dataSource = self
        productionTableView.delegate = self

        productionTableView.register(ProductionItemCell.self, forCellReuseIdentifier: "ProductionItemCell")
        productionTableView.rowHeight = 50
    }

    private func updateCell(with model: ProductionItem?) {
        guard let model = model else { return }

        if model.ingredients.isEmpty {
            descriptionBottomConstraint?.deactivate()
            productionTableView.snp.removeConstraints()
            productionTableView.removeFromSuperview()
            productionDescriptionView.snp.makeConstraints { make in
                descriptionBottomConstraint = make.bottom.lessThanOrEqualToSuperview().inset(15).constraint
            }
        }
        productionDescriptionView.updateWithModel(with: model)
        productionTableView.reloadData()
    }

    static func calculateHeight(for model: ProductionItem?) -> CGFloat {
        guard let model = model else { return 0 }
        var basicHeight: CGFloat = 32 + 15 + 15
        if !model.ingredients.isEmpty {
            model.ingredients.forEach { ingredient in
                basicHeight += calculateHeight(for: ingredient)
            }
        }

        return basicHeight
    }
}

extension ProductionItemCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let model = model else { return 0 }
        return ProductionItemCell.calculateHeight(for: model.ingredients[indexPath.row])
    }
}

extension ProductionItemCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = model?.ingredients.count else { return 0 }
        return count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let productionItem = model else { return UITableViewCell()}
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProductionItemCell", for: indexPath) as? ProductionItemCell else { return UITableViewCell() }
        cell.model = productionItem.ingredients[indexPath.row]
        cell.nestingLevel = nestingLevel + 1
        return cell
    }
}
