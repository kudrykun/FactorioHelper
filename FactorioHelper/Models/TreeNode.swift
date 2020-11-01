//
//  TreeNode.swift
//  FactorioHelper
//
//  Created by Sergey Vasilenko on 17.09.2020.
//  Copyright © 2020 kudrykun. All rights reserved.
//

import Foundation

public class TreeNode<T>: Equatable where T:Comparable {
    public static func == (lhs: TreeNode<T>, rhs: TreeNode<T>) -> Bool {
        guard lhs.value == rhs.value && lhs.children.count == rhs.children.count else { return false }

        var isChildrenEqual = true

        let lhsChildren = lhs.children.sorted{$0.value < $1.value}
        let rhsChildren = rhs.children.sorted{$0.value < $1.value}
        for (index, _) in lhs.children.enumerated() {
            isChildrenEqual = isChildrenEqual && (lhsChildren[index] == rhsChildren[index])
        }

        return isChildrenEqual
    }

    var value: T
    weak var parent: TreeNode<T>?
    var children: [TreeNode<T>] = []

    public init(_ value: T) {
        self.value = value
    }

    public func addChild(_ node: TreeNode<T>) {
        children.append(node)
        node.parent = self
    }

    public func flattened() -> [T]{
        var resultArray = [T]()

        resultArray.append(value)

        children.forEach { child in
            resultArray.append(contentsOf: child.flattened())
        }

        return resultArray
    }
}
