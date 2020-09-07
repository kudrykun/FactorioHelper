//
//  TimeSelectionView.swift
//  FactorioHelper
//
//  Created by Sergey Vasilenko on 07.09.2020.
//  Copyright © 2020 kudrykun. All rights reserved.
//

import UIKit
import SnapKit

class TimeSelectionView: UIView {

    var secondsTextFieldChanged: ((String) -> Void)?

    private let secondsTextField: UITextField = {
        let textField = UITextField()
        textField.text = "1"
        return textField
    }()

    private let textLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.text = "items per second"
        return label
    }()

    required init?(coder: NSCoder) {
        fatalError("required init?(coder:) has not been implemented")
    }

    init() {
        super.init(frame: .zero)
        setupSubviews()
    }

    private func setupSubviews() {
        addSubview(secondsTextField)
        addSubview(textLabel)
        setupConstraints()

        secondsTextField.delegate = self
    }

    private func setupConstraints() {
        secondsTextField.snp.makeConstraints { make in
            make.centerY.height.equalToSuperview()
            make.left.equalToSuperview().offset(15)
            make.width.equalTo(50)
        }

        textLabel.snp.makeConstraints { make in
            make.centerY.height.equalToSuperview()
            make.left.equalTo(secondsTextField.snp.right).offset(5)
            make.right.lessThanOrEqualToSuperview().inset(15)
        }
    }
}

extension TimeSelectionView: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        secondsTextFieldChanged?(textField.text ?? "")
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        secondsTextFieldChanged?(textField.text ?? "")
        return true
    }
}
