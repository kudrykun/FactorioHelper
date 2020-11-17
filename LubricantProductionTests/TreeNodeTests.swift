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

    var nodeA: TreeNode<String>!
    var nodeB: TreeNode<String>!
    var nodeC: TreeNode<String>!
    var nodeD: TreeNode<String>!
    var nodeE: TreeNode<String>!
    var nodeF: TreeNode<String>!
    var nodeG: TreeNode<String>!
    var nodeH: TreeNode<String>!
    var nodeI: TreeNode<String>!

    override func setUpWithError() throws {
        nodeA = TreeNode<String>("A")
        nodeB = TreeNode<String>("B")
        nodeC = TreeNode<String>("C")
        nodeD = TreeNode<String>("D")
        nodeE = TreeNode<String>("E")
        nodeF = TreeNode<String>("F")
        nodeG = TreeNode<String>("G")
        nodeH = TreeNode<String>("H")
        nodeI = TreeNode<String>("I")

        nodeA.addChild(nodeB)
        nodeA.addChild(nodeC)
        nodeA.addChild(nodeD)

        nodeB.addChild(nodeG)
        nodeB.addChild(nodeH)
        nodeH.addChild(nodeI)

        nodeD.addChild(nodeE)
        nodeD.addChild(nodeF)
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
        XCTAssertEqual(nodeA.flattened(), [nodeA, nodeB, nodeG, nodeH, nodeI, nodeC, nodeD, nodeE, nodeF], "Wrong flattening order!")
    }

    func testDescendantsCounting() {
        XCTAssertEqual(nodeA.descendantsCount(), 8)
        XCTAssertEqual(nodeB.descendantsCount(), 3)
        XCTAssertEqual(nodeG.descendantsCount(), 0)
    }

    func testTreeTraversalEqual() {
        let nodeA1 = TreeNode<String>("A1")
        let nodeB1 = TreeNode<String>("B1")
        let nodeC1 = TreeNode<String>("C1")
        let nodeD1 = TreeNode<String>("D1")
        let nodeE1 = TreeNode<String>("E1")
        let nodeF1 = TreeNode<String>("F1")
        let nodeG1 = TreeNode<String>("G1")
        let nodeH1 = TreeNode<String>("H1")
        let nodeI1 = TreeNode<String>("I1")
        nodeA1.addChild(nodeB1)
        nodeA1.addChild(nodeC1)
        nodeA1.addChild(nodeD1)

        nodeB1.addChild(nodeG1)
        nodeB1.addChild(nodeH1)
        nodeH1.addChild(nodeI1)

        nodeD1.addChild(nodeE1)
        nodeD1.addChild(nodeF1)

        nodeA.traverseTree() { value in
            value.value = "\(value.value)1"
        }

        XCTAssertEqual(nodeA1, nodeA)
    }

    func testTreeTraversalNotEqual() {
        let nodeA1 = TreeNode<String>("A1")
        let nodeB1 = TreeNode<String>("B1")
        let nodeC1 = TreeNode<String>("C1")
        let nodeD1 = TreeNode<String>("D1")
        let nodeE1 = TreeNode<String>("E1")
        let nodeF1 = TreeNode<String>("F")
        let nodeG1 = TreeNode<String>("G1")
        let nodeH1 = TreeNode<String>("H1")
        let nodeI1 = TreeNode<String>("I1")
        nodeA1.addChild(nodeB1)
        nodeA1.addChild(nodeC1)
        nodeA1.addChild(nodeD1)

        nodeB1.addChild(nodeG1)
        nodeB1.addChild(nodeH1)
        nodeH1.addChild(nodeI1)

        nodeD1.addChild(nodeE1)
        nodeD1.addChild(nodeF1)

        nodeA.traverseTree() { value in
            value.value = "\(value.value)1"
        }

        XCTAssertNotEqual(nodeA1, nodeA)
    }

    func testTreeTraversalEqualOnlyRoot() {
        let nodeA1 = TreeNode<String>("A1")
        let nodeA = TreeNode<String>("A")
        nodeA.traverseTree() { value in
            value.value = "\(value.value)1"
        }

        XCTAssertEqual(nodeA1, nodeA)
    }

    func testTreeTraversalWithStoppper() {
        let nodeA1 = TreeNode<String>("A1")
        let nodeB1 = TreeNode<String>("B1")
        let nodeC1 = TreeNode<String>("C1")
        let nodeD1 = TreeNode<String>("D1")
        let nodeE1 = TreeNode<String>("E")
        let nodeF1 = TreeNode<String>("F")
        let nodeG1 = TreeNode<String>("G1")
        let nodeH1 = TreeNode<String>("H1")
        let nodeI1 = TreeNode<String>("I1")
        nodeA1.addChild(nodeB1)
        nodeA1.addChild(nodeC1)
        nodeA1.addChild(nodeD1)

        nodeB1.addChild(nodeG1)
        nodeB1.addChild(nodeH1)
        nodeH1.addChild(nodeI1)

        nodeD1.addChild(nodeE1)
        nodeD1.addChild(nodeF1)

        nodeA.traverseTree(wtih: { value in
            value.value = "\(value.value)1"
        }, proceed: { value in
            return value != nodeD
        })

        XCTAssertEqual(nodeA1, nodeA)
    }

    func testTreeTraversalWithStoppper1() {
        let nodeA1 = TreeNode<String>("A1")
        let nodeB1 = TreeNode<String>("B1")
        let nodeC1 = TreeNode<String>("C1")
        let nodeD1 = TreeNode<String>("D1")
        let nodeE1 = TreeNode<String>("E1")
        let nodeF1 = TreeNode<String>("F1")
        let nodeG1 = TreeNode<String>("G1")
        let nodeH1 = TreeNode<String>("H1")
        let nodeI1 = TreeNode<String>("I1")
        nodeA1.addChild(nodeB1)
        nodeA1.addChild(nodeC1)
        nodeA1.addChild(nodeD1)

        nodeB1.addChild(nodeG1)
        nodeB1.addChild(nodeH1)
        nodeH1.addChild(nodeI1)

        nodeD1.addChild(nodeE1)
        nodeD1.addChild(nodeF1)

        nodeA.traverseTree(wtih: { value in
            value.value = "\(value.value)1"
        }, proceed: { value in
            return value != nodeD
        })

        XCTAssertNotEqual(nodeA1, nodeA)
    }
}
