//
//  MainViewController.swift
//  FactorioHelper
//
//  Created by Sergey Vasilenko on 26.11.2020.
//  Copyright © 2020 kudrykun. All rights reserved.
//

import UIKit
import SnapKit

class MainViewController: UIViewController, MainViewControllerInput {

    //TODO: отрефактори, грязно получилось
    func setGroups(_ groups: [String : Group]) {
        self.groups = groups

        sortedGroups = groups.map{$0.value}
        sortedGroups.sort{ $0.order < $1.order}
        currentGroup = sortedGroups.first

        segmentedControl?.removeFromSuperview()
        setupSegmentedControl()
        guard let segmentedControl = segmentedControl else { return }
        view.addSubview(segmentedControl)
        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.height.equalTo(60)
        }
    }

    var presenter: MainViewControllerOuput?
    let configurator = MainConfigurator()



    private var groups = [String : Group]()
    private var sortedGroups: [Group] = []
    private var currentGroup: Group?

    private let collectionView: UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        layout.sectionInset = .init(top: 1.5, left: 0, bottom: 1.5, right: 0)
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 2
        layout.itemSize = .init(width: MainViewController.itemWidth, height: MainViewController.itemWidth)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(RecipeListCell.self, forCellWithReuseIdentifier: "\(RecipeListCell.self)")
        collectionView.register(RecipeListEmptyCell.self, forCellWithReuseIdentifier: "\(RecipeListEmptyCell.self)")
        return collectionView
    }()

    private var segmentedControl: UISegmentedControl?

    static var itemWidth: CGFloat {
        get {
            let basicItemWidth: CGFloat = 45
            let interItemSpacing: CGFloat = 2
            let screenWidth = UIScreen.main.bounds.width
            var itemsInLine = (screenWidth / basicItemWidth).rounded(.down)
            itemsInLine = ((screenWidth - itemsInLine * interItemSpacing) / basicItemWidth).rounded(.down)
            return basicItemWidth + ((screenWidth - itemsInLine * interItemSpacing) - itemsInLine * basicItemWidth) / itemsInLine
        }
    }

    static var itemsInLine: Int {
        let basicItemWidth: CGFloat = 45
        let interItemSpacing: CGFloat = 2
        let screenWidth = UIScreen.main.bounds.width
        var itemsInLine = (screenWidth / basicItemWidth).rounded(.down)
        itemsInLine = ((screenWidth - itemsInLine * interItemSpacing) / basicItemWidth).rounded(.down)
        return Int(itemsInLine)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.commonBackgroundColor

        view.addSubview(collectionView)

        setupCollectionView()
        setupConstraints()

        presenter?.viewDidLoad(self)
    }

    func setupSegmentedControl() {
        let imagesForSegmentedControl = sortedGroups.compactMap { UIImage(named: $0.icon ?? "")?.withRenderingMode(.alwaysOriginal) }

        segmentedControl = UISegmentedControl(items: imagesForSegmentedControl)
        guard let segmentedControl = segmentedControl else { return }
        for (index,image) in imagesForSegmentedControl.enumerated() {
            let newSize = CGSize(width: 50, height: 50)
            segmentedControl.setImage(image.scaledToSize(newSize), forSegmentAt: index)
        }
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentSelected(_:)), for: .valueChanged)
        segmentedControl.contentMode = .scaleAspectFill
        segmentedControl.apportionsSegmentWidthsByContent = true
        segmentedControl.selectedSegmentTintColor = Colors.segmentedControlSelectedColor
    }

    @objc func segmentSelected(_ sender: Any) {
        guard let segmentedControl = segmentedControl else { return }
        currentGroup = sortedGroups[segmentedControl.selectedSegmentIndex]
        collectionView.reloadData()
    }

    func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self

        let blackView = UIView()
        blackView.backgroundColor = Colors.commonBackgroundColor
        collectionView.backgroundView = blackView
    }

    func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(70)
        }
    }
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        guard let subgroup = currentGroup?.subgroups[indexPath.section] else { return }

        guard indexPath.row < subgroup.items.count else { return }

        let recipeName = subgroup.items[indexPath.row].name
        guard let recipe = RecipesProvider.recipes[recipeName] else { return }

        presenter?.view(self, didSelectCellWith: recipe)
    }
}

extension MainViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        let count = currentGroup?.subgroups.count ?? 0
        return count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = currentGroup?.subgroups[section].items.count else { return 0 }
        let neededRows = (Float(count) /  Float(MainViewController.itemsInLine)).rounded(.up)
        let totalCount = Int(neededRows) * MainViewController.itemsInLine
        return totalCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let subgroup = currentGroup?.subgroups[indexPath.section] else { return UICollectionViewCell() }

        if indexPath.row < subgroup.items.count {
            let item = subgroup.items[indexPath.row]

            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(RecipeListCell.self)", for: indexPath) as? RecipeListCell else { return UICollectionViewCell() }
            cell.image = item.croppedIcon
            cell.accessibilityIdentifier = item.name
            print("createdCell \(item.name) \t\t \(item.subgroup) \t \(item.order)")
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(RecipeListEmptyCell.self)", for: indexPath) as? RecipeListEmptyCell else { return UICollectionViewCell() }
            return cell
        }
    }
}
