//
//  SimpleRecipeTableViewCell.swift
//  FactorioHelper
//
//  Created by Sergey Vasilenko on 04.09.2020.
//  Copyright © 2020 kudrykun. All rights reserved.
//

import UIKit
import SnapKit

struct SimpleRecipeCellModel {
    var image: UIImage
    var title: String
}

class SimpleRecipeTableViewCell: UITableViewCell {

    var model: SimpleRecipeCellModel? {
        didSet {
            iconImageView.image = model?.image
            titleLabel.text = model?.title
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

    required init?(coder: NSCoder) {
        fatalError("init?(coder:) has not been implemented")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(iconImageView)
        addSubview(titleLabel)
        setupConstraints()
    }

    private func setupConstraints() {
        iconImageView.snp.makeConstraints { make in
            make.width.height.equalTo(self.snp.height)
            make.top.bottom.left.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(iconImageView.snp.right).offset(15)
            make.right.equalToSuperview()
            make.height.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
}
