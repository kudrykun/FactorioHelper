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

    private let resultTextLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textColor = .label
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }

    private func setupView() {
        view.backgroundColor = .systemBackground

        setupHeaderView()
        setupTimeSelectionView()

        view.addSubview(resultTextLabel)
        resultTextLabel.snp.makeConstraints { make in
            make.top.equalTo(timeSelectionView.snp.bottom).offset(15)
            make.bottom.lessThanOrEqualToSuperview().inset(15)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().inset(15)
        }

        guard let recipe = model else { return }
        let productionItem = ProductionCalculator.getProductionItem(for: recipe, countPerSecond: 1)
        guard let item = productionItem else { return }

        resultTextLabel.text = ProductionCalculator.getProductionDescriptionString(for: item)
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
            let productionItem = ProductionCalculator.getProductionItem(for: recipe, countPerSecond: time)
            guard let item = productionItem else { return }

            self?.resultTextLabel.text = ProductionCalculator.getProductionDescriptionString(for: item)
        }
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
    }

    private func findRecipe(for ingredient: Ingredient) -> Recipe? {
        let recipes = RecipesProvider.getRecipes()
        guard let searchedRecipeIndex = recipes.firstIndex(where: { recipe in
            return recipe.name == ingredient.name
        }) else { return nil }

        return recipes[searchedRecipeIndex]
    }
}
