//
//  RecipeListEmptyCell.swift
//  FactorioHelper
//
//  Created by Sergey Vasilenko on 15.10.2020.
//  Copyright © 2020 kudrykun. All rights reserved.
//

import UIKit

class RecipeListEmptyCell: UICollectionViewCell {

    let grayGradientView: UIView = {
        let view = UIView()
        return view
    }()

    let grayBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.itemCollectionBackgroundColor
        return view
    }()

    required init?(coder: NSCoder) {
        fatalError("init?(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(grayGradientView)
        addSubview(grayBackgroundView)

        grayBackgroundView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalToSuperview().multipliedBy(0.65)
        }

        grayGradientView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalToSuperview().multipliedBy(0.7)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupGradientView()
    }

    private func setupGradientView() {
        let layer = CAGradientLayer()
        layer.colors = [Colors.itemCellGradientFinishColor.cgColor, Colors.itemCellGradientMiddleColor.cgColor,Colors.itemCellGradientMiddleColor.cgColor,Colors.itemCellGradientStartColor.cgColor]
        layer.frame = grayGradientView.bounds
        layer.locations = [0.0, 0.15, 0.85]
        grayGradientView.layer.addSublayer(layer)
    }
}
