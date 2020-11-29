//
//  HeaderCell.swift
//  FactorioHelper
//
//  Created by Sergey Vasilenko on 29.11.2020.
//  Copyright © 2020 kudrykun. All rights reserved.
//

import UIKit

class HeaderCell: UITableViewCell {

    var appName: String? {
        didSet {
            appNameLabel.text = appName
        }
    }

    var appVersion: String? {
        didSet {
            appVersionLabel.text = appVersion
        }
    }

    private let appIcon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "gearshape.fill")?.withTintColor(Colors.commonTextColor, renderingMode: .alwaysOriginal)
        view.contentMode = .scaleAspectFit
        return view
    }()

    private let appNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = Colors.commonTextColor
        return label
    }()

    private let appVersionLabel: UILabel = {
        let label = UILabel()
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
        addSubview(appNameLabel)
        addSubview(appVersionLabel)

        makeConstraints()
    }

    func makeConstraints() {
        appIcon.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.width.height.equalTo(100)
            make.centerX.equalToSuperview()
        }

        appNameLabel.snp.makeConstraints { make in
            make.top.equalTo(appIcon.snp.bottom).offset(15)
            make.width.equalToSuperview().inset(30)
            make.centerX.equalToSuperview()
        }

        appVersionLabel.snp.makeConstraints { make in
            make.top.equalTo(appNameLabel.snp.bottom).offset(10)
            make.width.equalToSuperview().inset(30)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(30)
        }
    }

}
