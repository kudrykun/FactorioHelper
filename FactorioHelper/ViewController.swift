//
//  ViewController.swift
//  FactorioHelper
//
//  Created by Sergey Vasilenko on 03.09.2020.
//  Copyright © 2020 kudrykun. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 100
        return tableView
    }()

    private var recipes = [Recipe]()

    override func viewDidLoad() {
        super.viewDidLoad()
        initRecipes()
        setupView()
    }

    private func initRecipes() {
        let parser = RecipeParser()
        recipes = parser.parseRecipes()
    }

    private func setupView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.register(SimpleRecipeTableViewCell.self, forCellReuseIdentifier: "SimpleRecipeTableViewCell")

        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SimpleRecipeTableViewCell", for: indexPath) as? SimpleRecipeTableViewCell else { return UITableViewCell() }
        cell.model = SimpleRecipeCellModelGenerator.generateModel(from: recipes[indexPath.row])
        return cell
    }
}


