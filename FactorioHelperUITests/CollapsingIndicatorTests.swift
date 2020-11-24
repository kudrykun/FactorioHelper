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

    //disabled cause chevron dissapears after first tap only in uitest, mb because of constraint
    //TODO: add to backlog in trello
    func testDisclosureIconRotatesOnTap() {
        goToInserterCell()
        let inserterProductionCell = XCUIApplication().tables["productionTableView"].cells["inserter"]
        var disclosureIconExpanded = inserterProductionCell.images["disclosure_icon_expanded"]
        var disclosureIconCollapsed = inserterProductionCell.images["disclosure_icon_collapsed"]

//        XCTAssertTrue(disclosureIconExpanded.exists, "Disclosure icon should be expanded by default!")
//        XCTAssertFalse(disclosureIconCollapsed.exists, "Disclosure icon should be expanded by default!")

        inserterProductionCell.tap()
        disclosureIconExpanded = inserterProductionCell.images["disclosure_icon_expanded"]
        disclosureIconCollapsed = inserterProductionCell.images["disclosure_icon_collapsed"]
        XCTAssertFalse(disclosureIconExpanded.waitForExistence(timeout: 1), "Disclosure icon should point down after tap!")
        XCTAssertTrue(disclosureIconCollapsed.waitForExistence(timeout: 1), "Disclosure icon should point down after tap!")


        inserterProductionCell.tap()
        disclosureIconExpanded = inserterProductionCell.images["disclosure_icon_expanded"]
        disclosureIconCollapsed = inserterProductionCell.images["disclosure_icon_collapsed"]
        XCTAssertTrue(disclosureIconExpanded.waitForExistence(timeout: 1), "Disclosure icon should be expanded after two taps!")
        XCTAssertFalse(disclosureIconCollapsed.waitForExistence(timeout: 1), "Disclosure icon should be expanded after two taps!")
    }
}
