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
            guard let recipe = model else { return }
            titleLabel.text = recipe.name
            iconImageView.image = IconProvider.getImage(for: recipe.name)
            self.ingredients = recipe.baseIngredients
            requiredTimeLabel.text = "\(recipe.baseProductionTime) s"
            resultCountLabel.text = "x\(recipe.baseProductionResultCount)"
        }
    }

    var ingredients = [Ingredient]()
    var productionItem: ProductionItem?

    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let resultCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        return label
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = .zero
        label.textColor = .label
        return label
    }()

    private let requiredTimeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = .label
        return label
    }()

    private let headerView: UIView = {
        let view = UIView()
        return view
    }()

    private let timeSelectionView: TimeSelectionView = {
        let view = TimeSelectionView()
        return view
    }()

    private let productionTableView: UITableView = {
        let tableView = UITableView()
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        guard let recipe = model else { return }
        productionItem = ProductionCalculator.getProductionItem(for: recipe, countPerSecond: 1)
    }

    private func setupView() {
        view.backgroundColor = .systemBackground

        setupHeaderView()
        setupTimeSelectionView()
        setupTableView()
    }

    private func setupHeaderView() {
        view.addSubview(headerView)
        headerView.addSubview(iconImageView)
        headerView.addSubview(resultCountLabel)
        headerView.addSubview(titleLabel)
        headerView.addSubview(requiredTimeLabel)

        setupHeaderViewConstraints()
    }

    private func setupTimeSelectionView() {
        view.addSubview(timeSelectionView)

        timeSelectionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
            make.top.equalTo(headerView.snp.bottom)
        }

        timeSelectionView.secondsTextFieldChanged = { [weak self] timeString in
            guard let time = Double(timeString) else { return }
            guard let recipe = self?.model else { return }
            self?.productionItem = ProductionCalculator.getProductionItem(for: recipe, countPerSecond: time)
            self?.productionTableView.reloadData()
        }
    }

    private func setupTableView() {
        view.addSubview(productionTableView)
        productionTableView.snp.makeConstraints { make in
            make.top.equalTo(timeSelectionView.snp.bottom).offset(15)
            make.left.right.bottom.equalToSuperview()
        }
        productionTableView.dataSource = self
        productionTableView.delegate = self

        productionTableView.register(ProductionItemCell.self, forCellReuseIdentifier: "ProductionItemCell")
        productionTableView.rowHeight = 250
    }

    private func setupHeaderViewConstraints() {
        headerView.snp.makeConstraints { make in
            make.height.equalTo(100)
            make.left.right.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }

        iconImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(60)
            make.left.greaterThanOrEqualToSuperview().offset(15)
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
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let productionItem = productionItem else { return 0 }
        return ProductionItemCell.calculateHeight(for: productionItem.ingredients[indexPath.row])
    }
}

extension RecipeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productionItem?.ingredients.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let productionItem = productionItem else { return UITableViewCell()}
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProductionItemCell", for: indexPath) as? ProductionItemCell else { return UITableViewCell() }
        cell.model = productionItem.ingredients[indexPath.row]
        return cell
    }


}
