//
//  base64ConverterTests.swift
//  SixtyFourTests
//
//  Created by Alessio Roberto on 02/07/2020.
//  Copyright © 2020 Alessio Roberto. All rights reserved.
//

@testable import SixtyFour
import XCTest

class base64ConverterTests: XCTestCase {
    func testFromImageToString() {
        let filePath = Bundle.main.url(forResource: "cat", withExtension: "jpg")
        let imageData = try? Data(contentsOf: filePath!)
        // Convert image Data to base64 encodded string
        let imageBase64String = imageData?.base64EncodedString()
        let newImageData = Data(base64Encoded: imageBase64String!)
        XCTAssertEqual(imageData, newImageData)
    }

    func testFromStringToImage() {
        XCTAssertNotNil(UIImage(base64String: MockOCRModel.imageString))
        XCTAssertNil(UIImage(base64String: MockOCRModel.text))
    }
}
