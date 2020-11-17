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

    private let disclosureIcon: UIImageView = {
        let imageview = UIImageView(image: UIImage(systemName: "chevron.right"))
        imageview.contentMode = .scaleAspectFit
        imageview.tintColor = Colors.segmentedControlSelectedColor
        return imageview
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
        contentView.addSubview(disclosureIcon)
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
            make.bottom.equalToSuperview().inset(15)
        }

        disclosureIcon.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.centerY.equalToSuperview()
            make.left.equalTo(productionDescriptionView.snp.right).offset(5)
            make.right.equalToSuperview().inset(10)
        }
    }

    private func updateCell(with model: TreeNode<ProductionItem>?) {
        guard let model = model else { return }
        descriptionViewOffsetConstraint?.update(offset: 15 * model.value.nestingLevel)
        productionDescriptionView.updateWithModel(with: model.value)
        if model.children.isEmpty {
            disclosureIcon.isHidden = true
            disclosureIcon.accessibilityIdentifier = nil
            return
        } else {
            if model.value.collapsedDescendants {
                disclosureIcon.transform = CGAffineTransform(rotationAngle: 0)
                disclosureIcon.accessibilityIdentifier = "disclosure_icon_collapsed"
            } else {
                disclosureIcon.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
                disclosureIcon.accessibilityIdentifier = "disclosure_icon_expanded"
            }
        }
    }
}
