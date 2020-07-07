//
//  SixtyFourUITests.swift
//  SixtyFourUITests
//
//  Created by Alessio Roberto on 04/07/2020.
//  Copyright © 2020 Alessio Roberto. All rights reserved.
//

import XCTest

class SixtyFourUITests: XCTestCase {
    func testActivityIndicators() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        XCTAssertFalse(app.activityIndicators["In progress"].exists)
    }

    func testTableViewVisible() {
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(app.tables.firstMatch.exists)
        XCTAssertEqual(app.tables.children(matching: .cell).count, 20)
    }
}
