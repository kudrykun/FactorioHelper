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

    func testSimpleFlattening() {
        let nodeA = TreeNode<String>("A")
        let nodeB = TreeNode<String>("B")
        let nodeC = TreeNode<String>("C")
        nodeA.addChild(nodeB)
        nodeA.addChild(nodeC)
        XCTAssertEqual(nodeA.flattened(), [nodeA, nodeB, nodeC], "Wrong flattening!")
    }

    func testSimpleFlatteningOrder() {
        let nodeA = TreeNode<String>("A")
        let nodeB = TreeNode<String>("B")
        let nodeC = TreeNode<String>("C")
        nodeA.addChild(nodeC)
        nodeA.addChild(nodeB)
        XCTAssertEqual(nodeA.flattened(), [nodeA, nodeC, nodeB], "Wrong flattening order!")
    }

    func testFlatteningWithOneElement() {
        let nodeA = TreeNode<String>("A")
        XCTAssertEqual(nodeA.flattened(), [nodeA], "Wrong flattening one element!")
    }

    func testFlattening() {
        let nodeA = TreeNode<String>("A")
        let nodeB = TreeNode<String>("B")
        let nodeC = TreeNode<String>("C")
        let nodeD = TreeNode<String>("D")
        let nodeE = TreeNode<String>("E")
        let nodeF = TreeNode<String>("F")
        let nodeG = TreeNode<String>("G")
        let nodeH = TreeNode<String>("H")
        let nodeI = TreeNode<String>("I")
        nodeA.addChild(nodeB)
        nodeA.addChild(nodeC)
        nodeA.addChild(nodeD)

        nodeB.addChild(nodeG)
        nodeB.addChild(nodeH)
        nodeH.addChild(nodeI)

        nodeD.addChild(nodeE)
        nodeD.addChild(nodeF)

        XCTAssertEqual(nodeA.flattened(), [nodeA, nodeB, nodeG, nodeH, nodeI, nodeC, nodeD, nodeE, nodeF], "Wrong flattening order!")
    }
}
