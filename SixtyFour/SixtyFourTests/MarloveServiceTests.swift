//
//  MarloveServiceTests.swift
//  SixtyFourTests
//
//  Created by Alessio Roberto on 03/07/2020.
//  Copyright © 2020 Alessio Roberto. All rights reserved.
//

@testable import SixtyFour
import Alamofire
import Moya
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

        waitForExpectations(timeout: 5.0, handler: nil)
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

    func testFailureResponse() {
        let customEndpointClosure = { (target: MarloveService) -> Endpoint in
            Endpoint(url: URL(target: target).absoluteString,
                     sampleResponseClosure: { .networkResponse(401, Data()) },
                     method: target.method,
                     task: target.task,
                     httpHeaderFields: target.headers)
        }

        let stubbingProvider = MoyaProvider<MarloveService>(endpointClosure: customEndpointClosure,
                                                            stubClosure: MoyaProvider.immediatelyStub)

        stubbingProvider.request(.items(sinceId: nil, maxId: nil)) { result in
            switch result {
            case let .success(moyaResponse):
                XCTAssertEqual(moyaResponse.statusCode, 401)
            case let .failure(moyaError):
                XCTAssert(false, moyaError.errorDescription ?? "Simple items request failed")
            }
        }
    }

    func testNetworkError() {
        let customEndpointClosure = { (target: MarloveService) -> Endpoint in
            Endpoint(url: URL(target: target).absoluteString,
                     sampleResponseClosure: { .networkError(NSError(domain: "timeout", code: 504, userInfo: nil)) },
                     method: target.method,
                     task: target.task,
                     httpHeaderFields: target.headers)
        }

        let stubbingProvider = MoyaProvider<MarloveService>(endpointClosure: customEndpointClosure,
                                                            stubClosure: MoyaProvider.immediatelyStub)

        stubbingProvider.request(.items(sinceId: nil, maxId: nil)) { result in
            switch result {
            case let .success(moyaResponse):
                XCTAssert(false)
            case let .failure(moyaError):
                XCTAssert(true, moyaError.errorDescription!)
            }
        }
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

    func testResponseDelay() {
        let sut = MoyaProvider<MarloveService>(stubClosure: MoyaProvider.delayedStub(5))

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

        waitForExpectations(timeout: 6.0, handler: nil)
    }

    func testSSLPinning() {
        let provider = MoyaProvider<MarloveService>(session: MarloveService.getSession())

        let expectation = self.expectation(description: #function)

        provider.request(.items(sinceId: nil, maxId: nil)) { result in
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
}
