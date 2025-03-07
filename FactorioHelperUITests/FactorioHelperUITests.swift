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

    func testUraniumsPresence() {
        //идем на третью вкладку
        app.segmentedControls.children(matching: .button).element(boundBy: 2).tap()

        //нажимаем рецепт ядерного топлива
        XCUIApplication().collectionViews.cells["nuclear-fuel"].children(matching: .other).element(boundBy: 1).tap()
        var uranium235cell = XCUIApplication().tables["productionTableView"].children(matching: .cell).matching(identifier: "uranium-235")
        checkUraniumCorretness(for: uranium235cell)
        XCUIApplication().navigationBars["FactorioHelper.ProductionView"].buttons["Back"].tap()

        //нажимаем рецепт ядерного стержня
        XCUIApplication().collectionViews.cells["uranium-fuel-cell"].children(matching: .other).element(boundBy: 1).tap()
        uranium235cell = XCUIApplication().tables["productionTableView"].children(matching: .cell).matching(identifier: "uranium-235")
        var uranium238cell = XCUIApplication().tables["productionTableView"].children(matching: .cell).matching(identifier: "uranium-238")
        checkUraniumCorretness(for: uranium238cell)
        checkUraniumCorretness(for: uranium235cell)
        XCUIApplication().navigationBars["FactorioHelper.ProductionView"].buttons["Back"].tap()

        //жмем назад
        //идем на четвертую вкладку
        app.segmentedControls.children(matching: .button).element(boundBy: 3).tap()
        //нажимаем рецепт ядерных патронов
        XCUIApplication().collectionViews.cells["uranium-rounds-magazine"].children(matching: .other).element(boundBy: 1).tap()
        uranium238cell = XCUIApplication().tables["productionTableView"].children(matching: .cell).matching(identifier: "uranium-238")
        checkUraniumCorretness(for: uranium238cell)
        XCUIApplication().navigationBars["FactorioHelper.ProductionView"].buttons["Back"].tap()

        //нажимаем рецепт ядерного заряда
        XCUIApplication().collectionViews.cells["uranium-cannon-shell"].children(matching: .other).element(boundBy: 1).tap()
        uranium238cell = XCUIApplication().tables["productionTableView"].children(matching: .cell).matching(identifier: "uranium-238")
        checkUraniumCorretness(for: uranium238cell)
        XCUIApplication().navigationBars["FactorioHelper.ProductionView"].buttons["Back"].tap()

        //нажимаем рецепт ядерного разрывного заряда
        XCUIApplication().collectionViews.cells["explosive-uranium-cannon-shell"].children(matching: .other).element(boundBy: 1).tap()
        uranium238cell = XCUIApplication().tables["productionTableView"].children(matching: .cell).matching(identifier: "uranium-238")
        checkUraniumCorretness(for: uranium238cell)
        XCUIApplication().navigationBars["FactorioHelper.ProductionView"].buttons["Back"].tap()

        //нажимаем рецепт ядерной бомбы
        XCUIApplication().collectionViews.cells["atomic-bomb"].children(matching: .other).element(boundBy: 1).tap()
        uranium235cell = XCUIApplication().tables["productionTableView"].children(matching: .cell).matching(identifier: "uranium-235")
        checkUraniumCorretness(for: uranium235cell)
    }

    func checkUraniumCorretness(for element: XCUIElementQuery) {
        XCTAssertTrue(element.staticTexts["itemsCountLabel"].exists)
        XCTAssertTrue(element.images["itemIcon"].exists)
        XCTAssertFalse(element.staticTexts["machinesCountLabel"].exists)
        XCTAssertFalse(element.buttons["machinePicker"].exists)
    }

    func testUraniumProcessingNotExist() {
        app.segmentedControls.children(matching: .button).element(boundBy: 2).tap()

        XCTAssertFalse(XCUIApplication().collectionViews.cells["uranium-processing"].exists)
        XCTAssertFalse(XCUIApplication().collectionViews.cells["nuclear-fuel-reprocessing"].exists)
        XCTAssertFalse(XCUIApplication().collectionViews.cells["kovarex-enrichment-process"].exists)
    }

    func testCollapsingAllInserter() {
        //проверка скрытия и открытия по манипулятору
        XCUIApplication().collectionViews.cells["inserter"].children(matching: .other).element(boundBy: 1).tap()
        let inserter = XCUIApplication().tables["productionTableView"].cells["inserter"]
        let circuit = XCUIApplication().tables["productionTableView"].cells["electronic-circuit"]
        XCTAssertTrue(inserter.exists)
        XCTAssertTrue(inserter.isHittable)
        XCTAssertTrue(circuit.exists)
        XCTAssertTrue(circuit.isHittable)

        inserter.tap()
        XCTAssertTrue(circuit.exists)
        XCTAssertFalse(circuit.isHittable)

        inserter.tap()
        XCTAssertTrue(circuit.exists)
        XCTAssertTrue(circuit.isHittable)
    }

    func testCopperPlateCollapseCorrectness() {
        XCUIApplication().collectionViews.cells["inserter"].children(matching: .other).element(boundBy: 1).tap()
        let copperCable = XCUIApplication().tables["productionTableView"].cells["copper-cable"]
        let copperPlate = XCUIApplication().tables["productionTableView"].cells["copper-plate"]
        let copperOre = XCUIApplication().tables["productionTableView"].cells["copper-ore"]

        XCTAssertTrue(copperCable.exists)
        XCTAssertTrue(copperCable.isHittable)
        XCTAssertTrue(copperPlate.exists)
        XCTAssertTrue(copperPlate.isHittable)
        XCTAssertTrue(copperOre.exists)
        XCTAssertTrue(copperOre.isHittable)

        copperPlate.tap()
        XCTAssertTrue(copperCable.exists)
        XCTAssertTrue(copperCable.isHittable)
        XCTAssertTrue(copperPlate.exists)
        XCTAssertTrue(copperPlate.isHittable)
        XCTAssertTrue(copperOre.exists)
        XCTAssertFalse(copperOre.isHittable)

        copperCable.tap()
        XCTAssertTrue(copperCable.exists)
        XCTAssertTrue(copperCable.isHittable)
        XCTAssertTrue(copperPlate.exists)
        XCTAssertFalse(copperPlate.isHittable)
        XCTAssertTrue(copperOre.exists)
        XCTAssertFalse(copperOre.isHittable)
    }

    func testChildStillCollapsedIfParentCollapsedAndDecollapsed() {
        XCUIApplication().collectionViews.cells["inserter"].children(matching: .other).element(boundBy: 1).tap()
        let copperCable = XCUIApplication().tables["productionTableView"].cells["copper-cable"]
        let copperOre = XCUIApplication().tables["productionTableView"].cells["copper-ore"]
        let copperPlate = XCUIApplication().tables["productionTableView"].cells["copper-plate"]
        let inserter = XCUIApplication().tables["productionTableView"].cells["inserter"]

        XCTAssertTrue(copperCable.isHittable)
        XCTAssertTrue(copperOre.isHittable)
        XCTAssertTrue(inserter.isHittable)

        copperCable.tap()
        XCTAssertFalse(copperOre.isHittable)
        XCTAssertFalse(copperPlate.isHittable)
        XCTAssertTrue(copperCable.isHittable)
        inserter.tap()
        XCTAssertFalse(copperCable.isHittable, "Copper cable should be hidden if inserter was tap!")
        inserter.tap()

        XCTAssertTrue(copperCable.isHittable)
        XCTAssertFalse(copperOre.isHittable, "Copper ore should be collapsed!")
        XCTAssertFalse(copperPlate.isHittable)
        XCTAssertTrue(inserter.isHittable)
    }

    func testStillСollapsedAfterChangeItemsPerSec() {
        XCUIApplication().collectionViews.cells["inserter"].children(matching: .other).element(boundBy: 1).tap()
        let copperOre = XCUIApplication().tables["productionTableView"].cells["copper-ore"]
        let circuit = XCUIApplication().tables["productionTableView"].cells["electronic-circuit"]

        XCTAssertTrue(copperOre.isHittable)
        circuit.tap()
        XCTAssertFalse(copperOre.isHittable)

        let app = XCUIApplication()
        app.textFields["secondsTextField"].tap()

        let key = app/*@START_MENU_TOKEN@*/.keys["1"]/*[[".keyboards.keys[\"1\"]",".keys[\"1\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        key.tap()
        app.toolbars["Toolbar"].buttons["Готово"].tap()

        XCTAssertFalse(copperOre.isHittable, "copper ore cell should remain hidden!")
    }

}
