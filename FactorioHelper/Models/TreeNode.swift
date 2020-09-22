//
//  TreeNode.swift
//  FactorioHelper
//
//  Created by Sergey Vasilenko on 17.09.2020.
//  Copyright © 2020 kudrykun. All rights reserved.
//

import Foundation

class TreeNode<T> {
    var value: T
    weak var parent: TreeNode<T>?
    var children: [TreeNode<T>] = []

    init(_ value: T) {
        self.value = value
    }

    func addChild(_ node: TreeNode<T>) {
        children.append(node)
        node.parent = self
    }
}
