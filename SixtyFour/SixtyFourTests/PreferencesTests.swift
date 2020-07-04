//
//  PreferencesTests.swift
//  SixtyFourTests
//
//  Created by Alessio Roberto on 04/07/2020.
//  Copyright © 2020 Alessio Roberto. All rights reserved.
//

@testable import SixtyFour
import XCTest

class PreferencesTests: XCTestCase {
    func testGetPreferences() {
        XCTAssertNoThrow(try Preferences.getToken())
    }

    func testGetToken() {
        let sut = try? Preferences.getToken()

        XCTAssertNotNil(sut)
    }
}
