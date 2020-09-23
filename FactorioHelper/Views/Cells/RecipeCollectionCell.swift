//
//  RecipeCollectionCell.swift
//  FactorioHelper
//
//  Created by Sergey Vasilenko on 22.09.2020.
//  Copyright © 2020 kudrykun. All rights reserved.
//

import UIKit
import SnapKit

class RecipeCollectionCell: UICollectionViewCell {

    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    required init?(coder: NSCoder) {
        fatalError("init?(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        backgroundColor = .gray

        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalToSuperview().multipliedBy(0.9)
        }
    }
}
