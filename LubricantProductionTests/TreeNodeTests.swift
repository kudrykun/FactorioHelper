//
//  TreeNodeTests.swift
//  LubricantProductionTests
//
//  Created by Sergey Vasilenko on 18.10.2020.
//  Copyright © 2020 kudrykun. All rights reserved.
//

import XCTest
import FactorioHelper

class TreeNodeTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSimpleEquality() {
        let tree1 = TreeNode<Int>(10)
        let tree2 = TreeNode<Int>(10)

        XCTAssertEqual(tree1, tree2, "Tree equality not working!")
    }

    func testSimpleInequality() {
        let tree1 = TreeNode<Int>(10)
        let tree2 = TreeNode<Int>(11)

        XCTAssertNotEqual(tree1, tree2, "Tree equality not working!")
    }

    func testEquality() {
        let tree1 = TreeNode<Int>(10)
        tree1.addChild(TreeNode<Int>(11))

        let tree2 = TreeNode<Int>(10)
        tree2.addChild(TreeNode<Int>(11))

        XCTAssertEqual(tree1, tree2, "Tree equality not working!")
    }

    func testEquality1() {
        let tree1 = TreeNode<Int>(10)
        tree1.addChild(TreeNode<Int>(11))
        tree1.addChild(TreeNode<Int>(12))

        let tree2 = TreeNode<Int>(10)
        tree2.addChild(TreeNode<Int>(12))
        tree2.addChild(TreeNode<Int>(11))

        XCTAssertEqual(tree1, tree2, "Tree equality not working!")
    }

    func testIneqaulity() {
        let tree1 = TreeNode<Int>(10)
        tree1.addChild(TreeNode<Int>(11))

        let tree2 = TreeNode<Int>(10)
        tree2.addChild(TreeNode<Int>(12))

        XCTAssertNotEqual(tree1, tree2, "Tree equality not working!")
    }

    func testIneqaulity1() {
        let tree1 = TreeNode<Int>(10)

        let tree2 = TreeNode<Int>(10)
        tree2.addChild(TreeNode<Int>(12))

        XCTAssertNotEqual(tree1, tree2, "Tree equality not working!")
    }

}
