//
//  MarloveServiceTests.swift
//  SixtyFourTests
//
//  Created by Alessio Roberto on 03/07/2020.
//  Copyright © 2020 Alessio Roberto. All rights reserved.
//

import Moya
@testable import SixtyFour
import XCTest

class MarloveServiceTests: XCTestCase {
    func testSimpleGet() {
        let sut = MoyaProvider<MarloveService>()

        let expectation = self.expectation(description: #function)

        sut.request(.items(sinceId: nil, maxId: nil)) { result in
            // do something with the result (read on for more details)
            switch result {
            case let .success(moyaResponse):
                XCTAssertEqual(moyaResponse.statusCode, 200)
            case let .failure(moyaError):
                XCTAssert(false, moyaError.errorDescription ?? "Simple items request failed")
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 2.0, handler: nil)
    }

    func testSinceIDGet() {
        let sut = MoyaProvider<MarloveService>()

        let expectation = self.expectation(description: #function)

        sut.request(.items(sinceId: "5e4eb3c56af30", maxId: nil)) { result in
            switch result {
            case let .success(moyaResponse):
                XCTAssertEqual(moyaResponse.statusCode, 200)
            case let .failure(moyaError):
                XCTAssert(false, moyaError.errorDescription ?? "Simple items request failed")
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 2.0, handler: nil)
    }

    func testMaxIDGet() {
        let sut = MoyaProvider<MarloveService>()

        let expectation = self.expectation(description: #function)

        sut.request(.items(sinceId: nil, maxId: "5e4eb3c56af30")) { result in
            switch result {
            case let .success(moyaResponse):
                XCTAssertEqual(moyaResponse.statusCode, 200)
            case let .failure(moyaError):
                XCTAssert(false, moyaError.errorDescription ?? "Simple items request failed")
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 2.0, handler: nil)
    }

    func testIgnoreDoubleParameters() {
        let sut = MoyaProvider<MarloveService>()

        let expectation = self.expectation(description: #function)

        sut.request(.items(sinceId: "5e4eb3c56af30", maxId: "5e4eb3c56af30")) { result in
            switch result {
            case let .success(moyaResponse):
                XCTAssertEqual(moyaResponse.statusCode, 200)
            case let .failure(moyaError):
                XCTAssert(false, moyaError.errorDescription ?? "Simple items request failed")
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 2.0, handler: nil)
    }

    func testResponseDecode() {
        let endpointClosure = { (target: MarloveService) -> Endpoint in
            Endpoint(url: URL(target: target).absoluteString,
                     sampleResponseClosure: { .networkResponse(200, target.sampleData) },
                     method: target.method,
                     task: target.task,
                     httpHeaderFields: target.headers)
        }

        let provider = MoyaProvider(endpointClosure: endpointClosure)

        let expectation = self.expectation(description: #function)

        provider.request(.items(sinceId: nil, maxId: nil)) { result in
            switch result {
            case let .success(moyaResponse):
                XCTAssertEqual(moyaResponse.statusCode, 200)
                let sut: [OCRModel]? = ModelConverter.convertToModels(from: moyaResponse.data)
                XCTAssertNotNil(sut)
                XCTAssertEqual(sut?.count, 10)
                XCTAssertEqual(sut?.first!.text, "30. mtcsz")
            case let .failure(moyaError):
                XCTAssert(false, moyaError.errorDescription ?? "Simple items request failed")
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 2.0, handler: nil)
    }
}
