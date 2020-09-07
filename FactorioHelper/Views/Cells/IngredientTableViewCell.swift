//
//  IngredientTableViewCell.swift
//  FactorioHelper
//
//  Created by Sergey Vasilenko on 05.09.2020.
//  Copyright © 2020 kudrykun. All rights reserved.
//

import UIKit
import SnapKit

class IngredientTableViewCell: UITableViewCell {

    var tableViewHeightConstraint: Constraint?
    var ingredients = [Ingredient]()

    var model: Ingredient? {
        didSet {
            iconImageView.image = IconProvider.getImage(for: model?.name ?? "")
            titleLabel.text = model?.name
            amountLabel.text = "x\(model?.amount ?? 0)"
            tableViewHeightConstraint?.deactivate()
            if let model = model, let recipe = RecipesProvider.findRecipe(for: model) {
                ingredients = RecipeHelper.getIngredients(for: recipe)
                let height = CGFloat((ingredients.count ?? 0) * 50)
                ingredientsTableView.snp.makeConstraints { make in
                    tableViewHeightConstraint = make.height.equalTo(height).constraint
                }
            }
            layoutIfNeeded()
        }
    }

    private let headerView: UIView = {
        let view = UIView()
        return view
    }()

    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .left
        return label
    }()

    private let amountLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    private let ingredientsTableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()

    required init?(coder: NSCoder) {
        fatalError("init?(coder:) has not been implemented")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(headerView)
        headerView.addSubview(iconImageView)
        headerView.addSubview(titleLabel)
        headerView.addSubview(amountLabel)
        addSubview(ingredientsTableView)
        setupConstraints()

        ingredientsTableView.delegate = self
        ingredientsTableView.dataSource = self
        ingredientsTableView.register(IngredientTableViewCell.self, forCellReuseIdentifier: "IngredientTableViewCell")
    }

    private func setupConstraints() {
        headerView.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.right.left.equalToSuperview()
        }

        iconImageView.snp.makeConstraints { make in
            make.width.height.equalTo(headerView.snp.height).multipliedBy(0.7)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(15)
        }

        amountLabel.snp.makeConstraints { make in
            make.left.equalTo(iconImageView.snp.right).offset(5)
            make.centerY.equalToSuperview()
            make.height.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(amountLabel.snp.right).offset(15)
            make.right.equalToSuperview().inset(15)
            make.height.equalToSuperview()
            make.centerY.equalToSuperview()
        }

        ingredientsTableView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.bottom.right.equalToSuperview()
            tableViewHeightConstraint = make.height.equalTo(0).constraint
            make.left.equalToSuperview().offset(30)
        }
    }

}

extension IngredientTableViewCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let recipe = RecipesProvider.findRecipe(for: ingredients[indexPath.row]) else { return }
        let vc = RecipeViewController()
        vc.model = recipe
//        self.navigationController?.pushViewController(vc, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let model = RecipesProvider.findRecipe(for: ingredients[indexPath.row]) else { return 0 }
        return CGFloat(RecipeHelper.getRecipeLineCount(for: model) * 50)
    }

}

extension IngredientTableViewCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientTableViewCell", for: indexPath) as? IngredientTableViewCell else { return UITableViewCell() }
        cell.model = ingredients[indexPath.row]
        return cell
    }
}
