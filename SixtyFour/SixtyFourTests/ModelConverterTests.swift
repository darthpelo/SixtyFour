//
//  ModelConverterTests.swift
//  SixtyFourTests
//
//  Created by Alessio Roberto on 02/07/2020.
//  Copyright © 2020 Alessio Roberto. All rights reserved.
//

@testable import SixtyFour
import XCTest

class ModelConverterTests: XCTestCase {
    func testSingleModel() {
        let value = 123
        let sut = ModelConverter.convertToData(value)
        XCTAssertNotNil(sut)
        XCTAssertEqual(value, ModelConverter.convertToModel(from: sut!))
    }

    func testListModel() {
        let values = [123, 321]
        let sut = ModelConverter.convertToData(values)
        XCTAssertNotNil(sut)
        XCTAssertEqual(values, ModelConverter.convertToModels(from: sut!))
    }
}
