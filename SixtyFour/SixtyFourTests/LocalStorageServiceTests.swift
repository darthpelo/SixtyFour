//
//  LocalStorageServiceTests.swift
//  SixtyFourTests
//
//  Created by Alessio Roberto on 06/07/2020.
//  Copyright © 2020 Alessio Roberto. All rights reserved.
//

@testable import SixtyFour
import XCTest

private var sut: LocalStorageService?

class LocalStorageServiceTests: XCTestCase {
    override class func setUp() {
        sut = LocalStorage("TEST")
    }

    func testWriteAndReadResultsSuccess() {
        let data: [OCRModel] = [OCRModel(ocrId: MockOCRModel.ocrId,
                                         text: MockOCRModel.text,
                                         confidence: MockOCRModel.confidence,
                                         imageString: MockOCRModel.imageString),
                                OCRModel(ocrId: MockOCRModel.ocrId,
                                         text: MockOCRModel.text,
                                         confidence: MockOCRModel.confidence,
                                         imageString: MockOCRModel.imageString)]
        XCTAssertTrue(sut!.write(data: data))

        let result: [OCRModel]? = sut!.read()
        XCTAssertNotNil(result)
        XCTAssertEqual(data, result!)
    }

    func testWriteAndReadResultSuccess() {
        XCTAssertTrue(sut!.write(data: OCRModel(ocrId: MockOCRModel.ocrId,
                                                text: MockOCRModel.text,
                                                confidence: MockOCRModel.confidence,
                                                imageString: MockOCRModel.imageString)))

        let result: OCRModel? = sut!.read()
        XCTAssertNotNil(result)
        XCTAssertEqual(OCRModel(ocrId: MockOCRModel.ocrId,
                                text: MockOCRModel.text,
                                confidence: MockOCRModel.confidence,
                                imageString: MockOCRModel.imageString), result)
    }
}
