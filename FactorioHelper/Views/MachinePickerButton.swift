//
//  MachinePickerButton.swift
//  FactorioHelper
//
//  Created by Sergey Vasilenko on 16.09.2020.
//  Copyright © 2020 kudrykun. All rights reserved.
//

import UIKit

class MachinePickerButton: UIButton {

    private var selectedMachine: MachineType?
    var machines: [MachineType] = [] {
        didSet {
            guard !machines.isEmpty else { return }
            selectedMachine = machines.first
        }
    }

    var didSelectMachine: ((MachineType) -> Void)?

    override var inputView: UIView? {
        machinePicker
    }

    var machine: MachineType = .Machine1 {
        didSet {
            setImage(machine.icon, for: .normal)
        }
    }

    override var canBecomeFirstResponder: Bool {
        true
    }

    //TODO: разобраться
    override open var inputAccessoryView: UIView? {
        let toolbar = UIToolbar()
        toolbar.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: 44)
        let closeButton = UIBarButtonItem(title: "Готово",
                                          style: .done,
                                          target: self,
                                          action: #selector(MachinePickerButton.didTapClose))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                    target: nil,
                                    action: nil)
        let items = [space, closeButton]
        toolbar.setItems(items, animated: false)
        toolbar.sizeToFit()

        return toolbar
    }

    required init?(coder: NSCoder) {
        fatalError("required init?(coder:) has not been implemented")
    }

    private let machinePicker: UIPickerView = {
        let picker = UIPickerView()
        return picker
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setImage(machine.icon, for: .normal)
        setupMachinePicker()
        addTarget(self, action: #selector(didTap), for: .touchUpInside)
    }

    private func setupMachinePicker() {
            machinePicker.delegate = self
            machinePicker.dataSource = self
    //        machinePicker.snp.makeConstraints { make in
    //            make.left.right.bottom.equalToSuperview()
    //            make.top.equalTo(view.snp.centerY)
    //        }
//            machineIcon.inputView = machinePicker
    }

    @objc func didTap() {
        if machines.count > 1 {
            becomeFirstResponder()
        }
    }

    @objc func didTapClose() {
        resignFirstResponder()
    }
}

extension MachinePickerButton: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedMachine = machines[row]
        setImage(machines[row].icon, for: .normal)
        didSelectMachine?(machines[row])
    }


}

extension MachinePickerButton: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return machines.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return machines[row].localizedName
    }
}
