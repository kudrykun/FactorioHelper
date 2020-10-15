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
        layout.sectionInset = .init(top: 1.5, left: 0, bottom: 1.5, right: 0)
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 2
        layout.itemSize = .init(width: ViewController.itemWidth, height: ViewController.itemWidth)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(RecipeListCell.self, forCellWithReuseIdentifier: "\(RecipeListCell.self)")
        collectionView.register(RecipeListEmptyCell.self, forCellWithReuseIdentifier: "\(RecipeListEmptyCell.self)")
        return collectionView
    }()

    private var segmentedControl: UISegmentedControl!

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
        navigationController?.navigationBar.barTintColor = Colors.commonBackgroundColor
        navigationController?.navigationBar.tintColor = Colors.commonTextColor
        navigationController?.navigationBar.barStyle = .black

        groups = GroupsParser.getGroups()

        sortedGroups = groups.map{$0.value}
        sortedGroups.sort{ $0.order < $1.order}
        currentGroup = sortedGroups.first

        let imagesForSegmentedControl = sortedGroups.compactMap { UIImage(named: $0.icon ?? "")?.withRenderingMode(.alwaysOriginal) }


        segmentedControl = UISegmentedControl(items: imagesForSegmentedControl)
        for (index,image) in imagesForSegmentedControl.enumerated() {
            segmentedControl.setImage(ViewController.image(from: image, scaledToSize: CGSize(width: 50, height: 50)), forSegmentAt: index)
        }
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(selectSegment(_:)), for: .valueChanged)
        segmentedControl.contentMode = .scaleAspectFill
        segmentedControl.apportionsSegmentWidthsByContent = true
        segmentedControl.selectedSegmentTintColor = Colors.segmentedControlSelectedColor

        view.addSubview(collectionView)
        view.addSubview(segmentedControl)

        collectionView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
        }

        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(collectionView.snp.top).offset(-10)
            make.height.equalTo(60)
        }

        collectionView.dataSource = self
        collectionView.delegate = self

        let blackView = UIView()
        blackView.backgroundColor = Colors.commonBackgroundColor
        collectionView.backgroundView = blackView
    }

    @objc func selectSegment(_ sender: Any) {
        currentGroup = sortedGroups[segmentedControl.selectedSegmentIndex]
        collectionView.reloadData()
    }

    static func image(from sourceImage: UIImage, scaledToSize newSize: CGSize) -> UIImage{
        UIGraphicsBeginImageContext(newSize)
        sourceImage.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image?.withRenderingMode(.alwaysOriginal) ?? UIImage()
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        guard let subgroup = currentGroup?.subgroups[indexPath.section] else { return }

        let vc = RecipeViewController()
        if indexPath.row < subgroup.items.count {
            let recipeName = subgroup.items[indexPath.row].name
            vc.model = RecipesProvider.findRecipe(with: recipeName)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension ViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        let count = currentGroup?.subgroups.count ?? 0
        return count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = currentGroup?.subgroups[section].items.count else { return 0 }
        let neededRows = (Float(count) /  Float(ViewController.itemsInLine)).rounded(.up)

        let totalCount = Int(neededRows) * ViewController.itemsInLine

        return totalCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let subgroup = currentGroup?.subgroups[indexPath.section] else { return UICollectionViewCell() }


        if indexPath.row < subgroup.items.count {
            let item = subgroup.items[indexPath.row]

            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(RecipeListCell.self)", for: indexPath) as? RecipeListCell else { return UICollectionViewCell() }
            cell.image = item.croppedIcon
            print("createdCell \(item.name) \t\t \(item.subgroup) \t \(item.order)")
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(RecipeListEmptyCell.self)", for: indexPath) as? RecipeListEmptyCell else { return UICollectionViewCell() }
            return cell
        }


        return UICollectionViewCell()
    }
}


