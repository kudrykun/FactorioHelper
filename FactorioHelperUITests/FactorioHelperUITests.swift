//
//  FactorioHelperUITests.swift
//  FactorioHelperUITests
//
//  Created by Sergey Vasilenko on 04.11.2020.
//  Copyright © 2020 kudrykun. All rights reserved.
//

import XCTest

class FactorioHelperUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app.terminate()
    }

    func testWaterIsWithoutMachineInLightOilRecipe() throws {
        //переходим на intermediate product
        app.segmentedControls.children(matching: .button).element(boundBy: 2).tap()

        //открываем дизельное топливо
        app.collectionViews.cells["light-oil"].children(matching: .other).element(boundBy: 1).tap()

        let waterCell = XCUIApplication().tables["productionTableView"].children(matching: .cell).matching(identifier: "water")

        let machineCounterLabel = waterCell.staticTexts["machinesCountLabel"]
        let machinePicker = waterCell.buttons["machinePicker"]

        XCTAssertTrue(!machineCounterLabel.exists)
        XCTAssertTrue(!machinePicker.exists)
    }

    func testWaterIsWithoutMachineInSpidertronRecipe() throws {
        //переходим на intermediate product
        app.segmentedControls.children(matching: .button).element(boundBy: 0).tap()

        //открываем дизельное топливо
        app.collectionViews.cells["spidertron"].children(matching: .other).element(boundBy: 1).tap()

        let waterCell = XCUIApplication().tables["productionTableView"].children(matching: .cell).matching(identifier: "water")

        let machineCounterLabel = waterCell.staticTexts["machinesCountLabel"]
        let machinePicker = waterCell.buttons["machinePicker"]

        XCTAssertTrue(!machineCounterLabel.exists)
        XCTAssertTrue(!machinePicker.exists)
    }

    func testThereIsNoBarrelRecipes() {
        //переходим на intermediate product
        app.segmentedControls.children(matching: .button).element(boundBy: 2).tap()

        XCTAssertTrue(!app.collectionViews.cells["water-fill-barrel"].exists)
        XCTAssertTrue(!app.collectionViews.cells["light-oil-fill-barrel"].exists)
        XCTAssertTrue(!app.collectionViews.cells["lubricant-fill-barrel"].exists)
        XCTAssertTrue(!app.collectionViews.cells["heavy-oil-fill-barrel"].exists)
        XCTAssertTrue(!app.collectionViews.cells["crude-oil-fill-barrel"].exists)
        XCTAssertTrue(!app.collectionViews.cells["petroleum-gas-fill-barrel"].exists)
        XCTAssertTrue(!app.collectionViews.cells["sulfuric-acid-fill-barrel"].exists)

        XCTAssertTrue(!app.collectionViews.cells["water-empty-barrel"].exists)
        XCTAssertTrue(!app.collectionViews.cells["light-oil-empty-barrel"].exists)
        XCTAssertTrue(!app.collectionViews.cells["lubricant-empty-barrel"].exists)
        XCTAssertTrue(!app.collectionViews.cells["heavy-oil-empty-barrel"].exists)
        XCTAssertTrue(!app.collectionViews.cells["crude-oil-empty-barrel"].exists)
        XCTAssertTrue(!app.collectionViews.cells["petroleum-gas-empty-barrel"].exists)
        XCTAssertTrue(!app.collectionViews.cells["sulfuric-acid-empty-barrel"].exists)
    }

    func testOreCellsExistance() {
        app.segmentedControls.children(matching: .button).element(boundBy: 2).tap()

        //открываем дизельное топливо
        app.collectionViews.cells["iron-plate"].tap()

        let oreCell = XCUIApplication().tables["productionTableView"].children(matching: .cell).matching(identifier: "iron-ore")

        XCTAssertTrue(oreCell.staticTexts["itemsCountLabel"].exists)
        XCTAssertTrue(oreCell.images["itemIcon"].exists)
        XCTAssertFalse(oreCell.staticTexts["machinesCountLabel"].exists)
        XCTAssertFalse(oreCell.buttons["machinePicker"].exists)
    }
}
