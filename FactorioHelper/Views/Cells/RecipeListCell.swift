//
//  RecipeListCell.swift
//  FactorioHelper
//
//  Created by Sergey Vasilenko on 22.09.2020.
//  Copyright © 2020 kudrykun. All rights reserved.
//

import UIKit
import SnapKit

class RecipeListCell: UICollectionViewCell {

    let grayGradientView: UIView = {
        let view = UIView()
        return view
    }()

    let grayBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.itemCellBackgroundColor
        return view
    }()

    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    required init?(coder: NSCoder) {
        fatalError("init?(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(grayGradientView)
        addSubview(grayBackgroundView)
        addSubview(imageView)

        //TODO: TEMP
//        imageView.isHidden = true
//        grayBackgroundView.isHidden = true

        grayBackgroundView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalToSuperview().multipliedBy(0.93)
        }

        grayGradientView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalToSuperview().multipliedBy(0.85)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupGradientView()
        setupShadow()
        grayBackgroundView.layer.cornerRadius = 5
    }

    private func setupGradientView() {
        let layer = CAGradientLayer()
        layer.colors = [Colors.itemCellGradientFinishColor.cgColor, Colors.itemCellGradientMiddleColor.cgColor,Colors.itemCellGradientMiddleColor.cgColor,Colors.itemCellGradientStartColor.cgColor]
        layer.frame = grayGradientView.bounds
        layer.cornerRadius = 6
        layer.locations = [0.0, 0.15, 0.85]
        grayGradientView.layer.addSublayer(layer)
    }

    private func setupShadow() {
        grayGradientView.layer.shadowColor = UIColor(red: 35/255.0, green: 25/255.0, blue: 25/255.0, alpha: 1).cgColor
        grayGradientView.layer.shadowOpacity = 1
        grayGradientView.layer.shadowRadius = 5
        grayGradientView.layer.shadowOffset = .zero
    }
}
