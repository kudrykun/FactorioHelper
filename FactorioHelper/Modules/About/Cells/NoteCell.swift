//
//  NoteCell.swift
//  FactorioHelper
//
//  Created by Sergey Vasilenko on 29.11.2020.
//  Copyright © 2020 kudrykun. All rights reserved.
//

import UIKit

class NoteCell: UITableViewCell {

    private let label: UILabel = {
        let label = UILabel()
        label.textColor = Colors.commonTextColor
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum"
        return label
    }()

    required init?(coder: NSCoder) {
        fatalError("init?(coder:) has not been implemented")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(label)

        backgroundColor = Colors.menuCellColor
        selectionStyle = .none

        label.snp.makeConstraints { make in
            make.left.top.equalToSuperview().offset(15)
            make.right.bottom.equalToSuperview().inset(15)
        }
    }
}
