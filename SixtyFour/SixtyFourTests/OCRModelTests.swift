//
//  OCRModelTests.swift
//  SixtyFourTests
//
//  Created by Alessio Roberto on 02/07/2020.
//  Copyright © 2020 Alessio Roberto. All rights reserved.
//

@testable import SixtyFour
import XCTest

class OCRModelTests: XCTestCase {
    func testModelInit() {
        let sut = OCRModel(ocrId: MockOCRModel.ocrId,
                           text: MockOCRModel.text,
                           confidence: MockOCRModel.confidence,
                           imageString: MockOCRModel.imageString)
        XCTAssertEqual(sut.ocrId, MockOCRModel.ocrId)
        XCTAssertEqual(sut.text, MockOCRModel.text)
        XCTAssertEqual(sut.confidence, MockOCRModel.confidence)
        XCTAssertEqual(sut.imageString, MockOCRModel.imageString)
    }

    func testModelEquetable() {
        let sut = OCRModel(ocrId: MockOCRModel.ocrId,
                           text: MockOCRModel.text,
                           confidence: MockOCRModel.confidence,
                           imageString: MockOCRModel.imageString)

        XCTAssertEqual(sut, OCRModel(ocrId: MockOCRModel.ocrId,
                                     text: MockOCRModel.text,
                                     confidence: MockOCRModel.confidence,
                                     imageString: MockOCRModel.imageString))
    }

    func testModelAndLocalStorageRW() {
        let testLocalStorage = UserDefaults(suiteName: "TEST")!

        let sut = OCRModel(ocrId: MockOCRModel.ocrId,
                           text: MockOCRModel.text,
                           confidence: MockOCRModel.confidence,
                           imageString: MockOCRModel.imageString)

        testLocalStorage.ocrModel = ModelConverter.convertToData(sut)

        XCTAssertNotNil(testLocalStorage.ocrModel)

        XCTAssertEqual(sut, ModelConverter.convertToModel(from: testLocalStorage.ocrModel!))
    }
}
