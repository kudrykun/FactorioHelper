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
    private var sortedGroups: [Group] = []
    private var currentGroup: Group?

    private let collectionView: UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        layout.sectionInset = .init(top: 20, left: 0, bottom: 20, right: 0)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(RecipeCollectionCell.self, forCellWithReuseIdentifier: "\(RecipeCollectionCell.self)")
        return collectionView
    }()

    private var segmentedControl: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()

        groups = GroupsParser.getGroups()

        sortedGroups = groups.map{$0.value}
        currentGroup = sortedGroups.first

        segmentedControl = UISegmentedControl(items: sortedGroups.map{NSLocalizedString($0.name, comment: "")})
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(selectSegment(_:)), for: .valueChanged)

        view.addSubview(collectionView)
        view.addSubview(segmentedControl)

        collectionView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
        }

        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(collectionView.snp.top)
        }

        collectionView.dataSource = self
        collectionView.delegate = self

        let blackView = UIView()
        blackView.backgroundColor = .systemBackground
        collectionView.backgroundView = blackView
    }

    @objc func selectSegment(_ sender: Any) {
        currentGroup = sortedGroups[segmentedControl.selectedSegmentIndex]
        collectionView.reloadData()
    }
}

extension ViewController: UICollectionViewDelegate {

}

extension ViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        let count = currentGroup?.subgroups.count ?? 0
        return count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = currentGroup?.subgroups[section].items.count ?? 0
        return count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let item = currentGroup?.subgroups[indexPath.section].items[indexPath.row] else { return UICollectionViewCell() }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(RecipeCollectionCell.self)", for: indexPath) as? RecipeCollectionCell else { return UICollectionViewCell() }
        cell.image = RecipesProvider.findRecipe(with: item.name)?.croppedIcon
        print("createdCell for \(item.name)")
        return cell
    }
}


