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
        tableView.rowHeight = 50
        return tableView
    }()

    private var recipes = [Recipe]()

    private var filteredRecipes = [Recipe]()

    var searchController: UISearchController!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableViewData()
        setupView()
        setupSearchController()
    }

    private func setupView() {
        view.addSubview(tableView)
        setupTableView()
    }
    private func setupTableViewData() {
        recipes = RecipesProvider.getRecipes()
        filteredRecipes = recipes
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SimpleRecipeTableViewCell.self, forCellReuseIdentifier: "SimpleRecipeTableViewCell")

        let blackView = UIView()
        blackView.backgroundColor = .systemBackground
        tableView.backgroundView = blackView

        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func setupSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.sizeToFit()
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredRecipes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SimpleRecipeTableViewCell", for: indexPath) as? SimpleRecipeTableViewCell else { return UITableViewCell() }
        cell.model = SimpleRecipeCellModelGenerator.generateModel(from: filteredRecipes[indexPath.row])
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = RecipeViewController()
        vc.model = filteredRecipes[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let searchText = searchText.lowercased()
        filteredRecipes = searchText.isEmpty ? recipes : recipes.filter {
            let localizedName = $0.localizedName.lowercased()
            return localizedName.range(of: searchText) != nil
        }
        tableView.reloadData()
    }
}


