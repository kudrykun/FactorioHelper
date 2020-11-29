//
//  HeaderCell.swift
//  FactorioHelper
//
//  Created by Sergey Vasilenko on 29.11.2020.
//  Copyright © 2020 kudrykun. All rights reserved.
//

import UIKit

class HeaderCell: UITableViewCell {


    private let appIcon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "gearshape.fill")?.withTintColor(Colors.commonTextColor, renderingMode: .alwaysOriginal)
        view.contentMode = .scaleAspectFit
        return view
    }()

    private let appName: UILabel = {
        let label = UILabel()
        label.text = "Factorio Pruduction Calculator"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = Colors.commonTextColor
        return label
    }()

    private let appVersion: UILabel = {
        let label = UILabel()
        label.text = "Version 0.8"
        label.textAlignment = .center
        label.numberOfLines = 1
        label.textColor = Colors.versionTextColor
        return label
    }()

    required init?(coder: NSCoder) {
        fatalError("init?(coder:) has not been implemented")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = Colors.menuCellColor
        selectionStyle = .none

        addSubview(appIcon)
        addSubview(appName)
        addSubview(appVersion)

        makeConstraints()
    }

    func makeConstraints() {
        appIcon.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.width.height.equalTo(100)
            make.centerX.equalToSuperview()
        }

        appName.snp.makeConstraints { make in
            make.top.equalTo(appIcon.snp.bottom).offset(15)
            make.width.equalToSuperview().inset(30)
            make.centerX.equalToSuperview()
        }

        appVersion.snp.makeConstraints { make in
            make.top.equalTo(appName.snp.bottom).offset(10)
            make.width.equalToSuperview().inset(30)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(30)
        }
    }

}
