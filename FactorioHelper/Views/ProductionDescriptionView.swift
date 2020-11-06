//
//  ProductionDescriptionView.swift
//  FactorioHelper
//
//  Created by Sergey Vasilenko on 12.09.2020.
//  Copyright © 2020 kudrykun. All rights reserved.
//

import UIKit

class ProductionDescriptionView: UIView {

    var didSelectMachine: ((MachineType) -> Void)?

    private let itemIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let itemsCountLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = Colors.commonTextColor
        return label
    }()

    private let machinePicker: MachinePickerButton = {
        let machineButton = MachinePickerButton()
        return machineButton
    }()

    private let machinesCountLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = Colors.commonTextColor
        label.accessibilityIdentifier = "machinesCountLabel"
        return label
    }()

    required init?(coder: NSCoder) {
        fatalError("init?(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(itemIcon)
        addSubview(itemsCountLabel)
        addSubview(machinePicker)
        addSubview(machinesCountLabel)
        setupConstraints()

        machinePicker.didSelectMachine = { machine in
            self.didSelectMachine?(machine)
        }
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

        machinePicker.snp.makeConstraints { make in
            make.width.height.equalTo(32)
            make.centerY.equalToSuperview()
            make.left.greaterThanOrEqualTo(itemsCountLabel.snp.right).offset(30)
        }

        machinesCountLabel.snp.makeConstraints { make in
            make.left.equalTo(machinePicker.snp.right).offset(5)
            make.right.equalToSuperview().offset(-15)
            make.top.bottom.equalToSuperview()
        }
    }

    func updateWithModel(with model: ProductionItem?) {
        guard let model = model else { return }
        guard let recipe =  RecipesProvider.recipes[model.name] else { return }
        itemIcon.image = recipe.croppedIcon
        itemsCountLabel.text = "\(model.countPerSecond) \(NSLocalizedString("items/sec", comment: ""))"

        if let machinesNeeded = model.machinesNeeded {
            machinesCountLabel.text = "x\(Int(machinesNeeded.rounded(.up)))"
        }

        if model.machineType == nil {
            machinesCountLabel.accessibilityIdentifier = "machinesCountLabel-hidden"
            machinesCountLabel.isHidden = true
        } else {
            machinesCountLabel.accessibilityIdentifier = "machinesCountLabel"
            machinesCountLabel.isHidden = false
        }

        machinePicker.machine = model.machineType
        machinePicker.machines = ProductionCalculator.getPossibleMachineTypes(for: recipe)
    }
}
