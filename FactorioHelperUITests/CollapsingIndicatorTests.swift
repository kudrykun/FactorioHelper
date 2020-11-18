//
//  CollapsingIndicatorTests.swift
//  FactorioHelperUITests
//
//  Created by Sergey Vasilenko on 17.11.2020.
//  Copyright © 2020 kudrykun. All rights reserved.
//

import XCTest

class CollapsingIndicatorTests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func goToInserterCell() {
        XCUIApplication().collectionViews.cells["inserter"].children(matching: .other).element(boundBy: 1).tap()
    }

    func testDiclosureIcon() {
        goToInserterCell()
        isDisclosureIconVisibleOnInserterInInserter()
        isDisclosureIconVisibleOnCircuitInInserter()
        isDisclosureIconInvisibleOnCopperOreInInserter()
    }

    func isDisclosureIconVisibleOnInserterInInserter() {
        let inserterProductionCell = XCUIApplication().tables["productionTableView"].cells["inserter"]
        let iconVisible = inserterProductionCell.images["disclosure_icon_collapsed"].exists || inserterProductionCell.images["disclosure_icon_expanded"].exists
        XCTAssertTrue(iconVisible, "Disclosure icon should be visible on inserter!")
    }

    func isDisclosureIconVisibleOnCircuitInInserter() {
        let circuitProductionCell = XCUIApplication().tables["productionTableView"].cells["electronic-circuit"]
        let iconVisible = circuitProductionCell.images["disclosure_icon_collapsed"].exists || circuitProductionCell.images["disclosure_icon_expanded"].exists
        XCTAssertTrue(iconVisible, "Disclosure icon should be visible on circuit!")
    }

    func isDisclosureIconInvisibleOnCopperOreInInserter() {
        let copperOreProductionCell = XCUIApplication().tables["productionTableView"].cells["copper-ore"]
        let iconVisible = copperOreProductionCell.images["disclosure_icon_collapsed"].exists || copperOreProductionCell.images["disclosure_icon_expanded"].exists
        XCTAssertFalse(iconVisible, "Disclosure icon should not be visible on copperOre!")
    }
}
