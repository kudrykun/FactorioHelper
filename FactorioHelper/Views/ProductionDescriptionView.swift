//
//  ProductionDescriptionView.swift
//  FactorioHelper
//
//  Created by Sergey Vasilenko on 12.09.2020.
//  Copyright © 2020 kudrykun. All rights reserved.
//

import UIKit

class ProductionDescriptionView: UIView {

    private let itemIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let itemsCountLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    private let machineIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let machinesCountLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    required init?(coder: NSCoder) {
        fatalError("init?(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(itemIcon)
        addSubview(itemsCountLabel)
        addSubview(machineIcon)
        addSubview(machinesCountLabel)
        setupConstraints()
    }

    private func setupConstraints() {
        itemIcon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(15)
            make.width.height.equalTo(32)
        }

        itemsCountLabel.snp.makeConstraints { make in
            make.left.equalTo(itemIcon.snp.right).offset(5)
            make.top.bottom.equalToSuperview()
        }

        machineIcon.snp.makeConstraints { make in
            make.width.height.equalTo(32)
            make.centerY.equalToSuperview()
            make.left.greaterThanOrEqualTo(itemsCountLabel.snp.right).offset(30)
        }

        machinesCountLabel.snp.makeConstraints { make in
            make.left.equalTo(machineIcon.snp.right).offset(5)
            make.right.equalToSuperview().offset(-15)
            make.top.bottom.equalToSuperview()
        }
    }

    func updateWithModel(with model: ProductionItem?) {
        guard let model = model else { return }
        itemIcon.image = IconProvider.getImage(for: model.name)
        itemsCountLabel.text = "\(model.countPerSecond) \(NSLocalizedString("items/sec", comment: ""))"
        machineIcon.image = IconProvider.getImage(for: model.machineType)
        guard let machinesNeeded = model.machinesNeeded else { return }
        machinesCountLabel.text = "x\(Int(machinesNeeded.rounded(.up)))"
    }
}
