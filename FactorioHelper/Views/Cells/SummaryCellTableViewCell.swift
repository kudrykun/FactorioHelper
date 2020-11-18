//
//  SummaryCellTableViewCell.swift
//  FactorioHelper
//
//  Created by Sergey Vasilenko on 20.11.2020.
//  Copyright © 2020 kudrykun. All rights reserved.
//

import UIKit

class SummaryCellTableViewCell: UITableViewCell {

    private let machineIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let counterLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = Colors.commonTextColor
        return label
    }()

    var machineType: MachineType? {
        didSet {
            guard let machineType = machineType else { return }
            machineIcon.image = machineType.icon
        }
    }

    var machinesCount: Int? {
        didSet {
            guard let machinesCount = machinesCount else { return }
            counterLabel.text = "\(machinesCount) machines"
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init?(coder:) has not been implemented")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupConstraints()
    }

    private func setupView() {
        contentView.addSubview(machineIcon)
        contentView.addSubview(counterLabel)
        selectionStyle = .none

        backgroundColor = Colors.commonBackgroundColor
    }

    private func setupConstraints() {
        machineIcon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(15)
            make.width.height.equalTo(32)
        }

        counterLabel.snp.makeConstraints { make in
            make.left.equalTo(machineIcon.snp.right).offset(5)
            make.right.lessThanOrEqualToSuperview().inset(15)
            make.top.bottom.equalToSuperview()
        }
    }

}
