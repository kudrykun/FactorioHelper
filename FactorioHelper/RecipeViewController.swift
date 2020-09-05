//
//  RecipeViewController.swift
//  FactorioHelper
//
//  Created by Sergey Vasilenko on 05.09.2020.
//  Copyright © 2020 kudrykun. All rights reserved.
//

import UIKit
import SnapKit

class RecipeViewController: UIViewController {

    var model: Recipe? {
        didSet {
            titleLabel.text = model?.name
            iconImageView.image = IconProvider.getImage(for: model?.name ?? "")
            if let ingredients = model?.ingredients {
                self.ingredients = ingredients
            } else if let ingredients = model?.normal?.ingredients {
                self.ingredients = ingredients
            }
            requiredTimeLabel.text = "\(model?.energyRequired ?? 0.5) s"
            resultCountLabel.text = "x\(model?.resultCount ?? 1)"
        }
    }

    var ingredients = [Ingredient]()

    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let resultCountLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = .zero
        return label
    }()

    private let requiredTimeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        return label
    }()

    private let ingredientsTableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 50
        return tableView
    }()

    private let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }

    private func setupView() {
        view.addSubview(headerView)
        view.backgroundColor = .white
        headerView.addSubview(iconImageView)
        headerView.addSubview(resultCountLabel)
        headerView.addSubview(titleLabel)
        headerView.addSubview(requiredTimeLabel)
        view.addSubview(ingredientsTableView)

        ingredientsTableView.delegate = self
        ingredientsTableView.dataSource = self
        ingredientsTableView.register(IngredientTableViewCell.self, forCellReuseIdentifier: "IngredientTableViewCell")

        setupConstraints()
    }

    private func setupConstraints() {
        headerView.snp.makeConstraints { make in
            make.height.equalTo(100)
            make.left.right.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }

        iconImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(60)
            make.left.equalToSuperview().offset(15)
        }

        resultCountLabel.snp.makeConstraints { make in
            make.left.equalTo(iconImageView.snp.right).offset(5)
            make.centerY.height.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(resultCountLabel.snp.right).offset(15)
            make.centerY.height.equalToSuperview()
        }

        requiredTimeLabel.snp.makeConstraints { make in
            make.centerY.height.equalToSuperview()
            make.left.equalTo(titleLabel.snp.right).offset(15)
            make.right.equalToSuperview().inset(15)
        }

        ingredientsTableView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.bottom.left.right.equalToSuperview()
        }
    }

    private func findRecipe(for ingredient: Ingredient) -> Recipe? {
        let recipes = RecipesProvider.getRecipes()
        guard let searchedRecipeIndex = recipes.firstIndex(where: { recipe in
            return recipe.name == ingredient.name
        }) else { return nil }

        return recipes[searchedRecipeIndex]
    }
}

extension RecipeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let recipe = findRecipe(for: ingredients[indexPath.row]) else { return }
        let vc = RecipeViewController()
        vc.model = recipe
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

extension RecipeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientTableViewCell", for: indexPath) as? IngredientTableViewCell else { return UITableViewCell() }
        cell.model = ingredients[indexPath.row]
        return cell
    }
}
