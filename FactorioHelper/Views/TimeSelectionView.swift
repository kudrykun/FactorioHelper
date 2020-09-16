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

    private let requiredTextLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 1
        label.text = NSLocalizedString("required-items", comment: "")
        return label
    }()

    private let secondsTextField: UITextField = {
        let textField = UITextField()
        textField.text = "1"
        textField.textAlignment = .center
        textField.keyboardType = .decimalPad
        return textField
    }()

    private let textLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 1
        label.text = NSLocalizedString("items/sec", comment: "")
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
        addSubview(requiredTextLabel)
        addSubview(secondsTextField)
        addSubview(textLabel)
        setupConstraints()

        secondsTextField.delegate = self

        secondsTextField.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)
        secondsTextField.textColor = .placeholderText
        secondsTextField.backgroundColor = .systemBackground
        secondsTextField.layer.borderColor = UIColor.placeholderText.cgColor
        secondsTextField.layer.borderWidth = 1
        secondsTextField.layer.cornerRadius = 6

        secondsTextField.inputAccessoryView = {
            let toolbar = UIToolbar()
            toolbar.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: 44)
            let closeButton = UIBarButtonItem(title: "Готово",
                                              style: .done,
                                              target: self,
                                              action: #selector(TimeSelectionView.didTapClose))
            let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                        target: nil,
                                        action: nil)
            let items = [space, closeButton]
            toolbar.setItems(items, animated: false)
            toolbar.sizeToFit()

            return toolbar
        }()

    }

    private func setupConstraints() {
        requiredTextLabel.snp.makeConstraints { make in
            make.centerY.height.equalToSuperview()
            make.left.equalToSuperview().offset(15)
        }

        secondsTextField.snp.makeConstraints { make in
            make.centerY.height.equalToSuperview()
            make.left.equalTo(requiredTextLabel.snp.right).offset(5)
            make.width.equalTo(100)
        }

        textLabel.snp.makeConstraints { make in
            make.centerY.height.equalToSuperview()
            make.left.equalTo(secondsTextField.snp.right).offset(5)
            make.right.lessThanOrEqualToSuperview().inset(15)
        }
    }

    @objc func didTapClose() {
        secondsTextField.resignFirstResponder()
    }
}

extension TimeSelectionView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let newString = textField.text as NSString? else { return false }
        let finalString = newString.replacingCharacters(in: range, with: string).replacingOccurrences(of: ",", with: ".")
        if !finalString.isEmpty, Double(finalString) != nil {
            secondsTextFieldChanged?(finalString)
        }
        return true
    }
}
