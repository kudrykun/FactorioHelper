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

    private var recipes = [Recipe]()

    private var groups = [String : Group]()

    private let collectionView: UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        layout.sectionInset = .init(top: 20, left: 0, bottom: 20, right: 0)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(RecipeCollectionCell.self, forCellWithReuseIdentifier: "\(RecipeCollectionCell.self)")
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)

        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        collectionView.dataSource = self
        collectionView.delegate = self

        groups = GroupsParser.getGroups()
        print(groups)
    }
}

extension ViewController: UICollectionViewDelegate {

}

extension ViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        let count = groups["logistics"]?.subgroups.count ?? 0
        print("number of sections \(count)")
        return count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = groups["logistics"]?.subgroups[section].items.count ?? 0
        print("number of items in section \(count)")
        return count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

//        var itemsCounter = 0
//        var subgroup: Group!
//        guard let subgroups = (groups["logistics"]?.subgroups) else { return UICollectionViewCell() }
//        for sub in subgroups {
//            itemsCounter += sub.items.count
//            if indexPath.row < itemsCounter {
//                itemsCounter -= sub.items.count
//                subgroup = sub
//                break
//            }
//        }

        guard let item = groups["logistics"]?.subgroups[indexPath.section].items[indexPath.row] else { return UICollectionViewCell() }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(RecipeCollectionCell.self)", for: indexPath) as? RecipeCollectionCell else { return UICollectionViewCell() }
        cell.image = RecipesProvider.findRecipe(with: item.name)?.croppedIcon
        print("createdCell for \(item.name)")
        return cell
    }
}


