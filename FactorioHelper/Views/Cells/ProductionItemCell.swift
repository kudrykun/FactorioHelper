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

    var didSelectMachine: (() -> Void)?

    var model: TreeNode<ProductionItem>? {
        didSet {
            updateCell(with: model)
        }
    }

    private var descriptionViewOffsetConstraint: Constraint?

    private let productionDescriptionView: ProductionDescriptionView = {
        let view = ProductionDescriptionView()
        view.accessibilityIdentifier = "productionDescriptionView"
        return view
    }()

    required init?(coder: NSCoder) {
        fatalError("init?(coder:) has not been implemented")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupConstraints()
    }

    private func setupView() {
        contentView.addSubview(productionDescriptionView)
        selectionStyle = .none

        backgroundColor = Colors.commonBackgroundColor

        productionDescriptionView.didSelectMachine = { machine in
            self.model?.value.machineType = machine
            self.didSelectMachine?()
        }
    }

    private func setupConstraints() {

        productionDescriptionView.snp.makeConstraints { make in
            descriptionViewOffsetConstraint = make.left.equalToSuperview().offset(15).constraint
            make.top.equalToSuperview().offset(15)
            make.right.equalToSuperview().inset(15)
            make.bottom.equalToSuperview().inset(15)
        }
    }

    private func updateCell(with model: TreeNode<ProductionItem>?) {
        guard let model = model else { return }
        descriptionViewOffsetConstraint?.update(offset: 15 * model.value.nestingLevel)
        productionDescriptionView.updateWithModel(with: model.value)
    }
}
