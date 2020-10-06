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

        view.addSubview(collectionView)
        view.addSubview(segmentedControl)

        collectionView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
        }

        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(collectionView.snp.top)
            make.height.equalTo(60)
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
        let vc = RecipeViewController()
        guard let recipeName = currentGroup?.subgroups[indexPath.section].items[indexPath.row].name else { return }
        vc.model = RecipesProvider.findRecipe(with: recipeName)
        self.navigationController?.pushViewController(vc, animated: true)
    }
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


