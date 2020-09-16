//
//  RecipeDescriptionHeaderView.swift
//  FactorioHelper
//
//  Created by Sergey Vasilenko on 16.09.2020.
//  Copyright © 2020 kudrykun. All rights reserved.
//

import UIKit

class RecipeDescriptionHeaderView: UIView {

    var model: Recipe? {
        didSet {
            guard let recipe = model else { return }
            titleLabel.text = model?.localizedName
            iconImageView.image = recipe.croppedIcon
            requiredTimeLabel.text = "\(recipe.baseProductionTime) s"
            resultCountLabel.text = "x\(recipe.baseProductionResultCount)"
        }
    }

    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let resultCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        return label
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = .zero
        label.textColor = .label
        return label
    }()

    private let requiredTimeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = .label
        return label
    }()

    required init?(coder: NSCoder) {
        fatalError("required init?(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }

    private func setupView() {
        addSubview(iconImageView)
        addSubview(resultCountLabel)
        addSubview(titleLabel)
        addSubview(requiredTimeLabel)
    }

    private func setupConstraints() {
        iconImageView.snp.makeConstraints { make in
           make.centerY.equalToSuperview()
           make.width.height.equalTo(60)
           make.left.equalToSuperview().offset(15)
        }

        resultCountLabel.snp.makeConstraints { make in
           make.left.equalTo(iconImageView.snp.right).offset(5)
           make.centerY.height.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { make in
           make.left.equalTo(resultCountLabel.snp.right).offset(15)
           make.centerY.height.equalToSuperview()
        }

        requiredTimeLabel.snp.makeConstraints { make in
           make.centerY.height.equalToSuperview()
           make.left.equalTo(titleLabel.snp.right).offset(15)
           make.right.equalToSuperview().inset(15)
        }
    }
}
