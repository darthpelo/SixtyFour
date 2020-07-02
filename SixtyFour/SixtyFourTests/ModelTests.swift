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
        let sut = Ocr(ocrId: "5e4eb3c580b33", text: "23. strpn", confidence: 0.81, imageString: "")
    }
}
