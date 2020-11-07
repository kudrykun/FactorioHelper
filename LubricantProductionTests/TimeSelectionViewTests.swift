//
//  TimeSelectionViewTests.swift
//  LubricantProductionTests
//
//  Created by Sergey Vasilenko on 07.11.2020.
//  Copyright © 2020 kudrykun. All rights reserved.
//

import XCTest
@testable import FactorioHelper

class TimeSelectionViewTests: XCTestCase {
    func testExample() throws {
        let timeSelectionView = TimeSelectionView()
        XCTAssertTrue(timeSelectionView.isValidSecondsString(""), "\"\" should be valid value!")
        XCTAssertTrue(timeSelectionView.isValidSecondsString("0"), "0 should be valid value!")
        XCTAssertTrue(timeSelectionView.isValidSecondsString("0.1"), "0.1 should be valid value!")
        XCTAssertTrue(timeSelectionView.isValidSecondsString("1"), "1 should be valid value!")
        XCTAssertTrue(timeSelectionView.isValidSecondsString("100"), "100 should be valid value!")
        XCTAssertTrue(timeSelectionView.isValidSecondsString("999"), "999 should be valid value!")
        XCTAssertTrue(timeSelectionView.isValidSecondsString("1000"), "1000 should be valid value!")
        XCTAssertFalse(timeSelectionView.isValidSecondsString("1001"), "1001 should not be valid value!")
        XCTAssertFalse(timeSelectionView.isValidSecondsString("5000"), "5000 should not be valid value!")
        XCTAssertFalse(timeSelectionView.isValidSecondsString("5000"), "1001 should not be valid value!")
        XCTAssertFalse(timeSelectionView.isValidSecondsString(".0"), ".0 should not be valid value!")
        XCTAssertFalse(timeSelectionView.isValidSecondsString(".1"), ".1 should not be valid value!")
        XCTAssertFalse(timeSelectionView.isValidSecondsString("1.2.3"), "1.2.3 should not be valid value!")
    }
}
