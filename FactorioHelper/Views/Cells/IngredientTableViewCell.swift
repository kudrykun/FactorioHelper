//
//  IngredientTableViewCell.swift
//  FactorioHelper
//
//  Created by Sergey Vasilenko on 05.09.2020.
//  Copyright © 2020 kudrykun. All rights reserved.
//

import UIKit

class IngredientTableViewCell: UITableViewCell {

    var model: Ingredient? {
        didSet {
            iconImageView.image = IconProvider.getImage(for: model?.name ?? "")
            titleLabel.text = model?.name
            amountLabel.text = "x\(model?.amount ?? 0)"
        }
    }

    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .left
        return label
    }()

    private let amountLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    required init?(coder: NSCoder) {
        fatalError("init?(coder:) has not been implemented")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(iconImageView)
        addSubview(titleLabel)
        addSubview(amountLabel)
        setupConstraints()
    }

    private func setupConstraints() {
        iconImageView.snp.makeConstraints { make in
            make.width.height.equalTo(self.snp.height).multipliedBy(0.7)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(15)
        }

        amountLabel.snp.makeConstraints { make in
            make.left.equalTo(iconImageView.snp.right).offset(5)
            make.centerY.equalToSuperview()
            make.height.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(amountLabel.snp.right).offset(15)
            make.right.equalToSuperview()
            make.height.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }

}
