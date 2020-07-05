//
//  ListViewPresenterTests.swift
//  SixtyFourTests
//
//  Created by Alessio Roberto on 03/07/2020.
//  Copyright © 2020 Alessio Roberto. All rights reserved.
//

import Moya
@testable import SixtyFour
import XCTest

class HomeViewPresenterTests: XCTestCase {
    private func stubProviderSuccess() -> MoyaProvider<MarloveService> {
        let customEndpointClosure = { (target: MarloveService) -> Endpoint in
            Endpoint(url: URL(target: target).absoluteString,
                     sampleResponseClosure: { .networkResponse(200, target.sampleData) },
                     method: target.method,
                     task: target.task,
                     httpHeaderFields: target.headers)
        }

        return MoyaProvider<MarloveService>(endpointClosure: customEndpointClosure,
                                            stubClosure: MoyaProvider.immediatelyStub)
    }

    private func stubProviderFailure() -> MoyaProvider<MarloveService> {
        let customEndpointClosure = { (target: MarloveService) -> Endpoint in
            Endpoint(url: URL(target: target).absoluteString,
                     sampleResponseClosure: { .networkResponse(501, Data()) },
                     method: target.method,
                     task: target.task,
                     httpHeaderFields: target.headers)
        }

        return MoyaProvider<MarloveService>(endpointClosure: customEndpointClosure,
                                            stubClosure: MoyaProvider.immediatelyStub)
    }

    func testPresenterFirstLoadSuccess() {
        let sut = HomePresenter(provider: stubProviderSuccess())

        let expectation = self.expectation(description: #function)

        sut.firstLoad(HomeViewController()) {
            XCTAssertEqual(sut.dataSourceElements(), 10)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func testPresenterFirstLoadFailure() {
        let sut = HomePresenter(provider: stubProviderFailure())

        let expectation = self.expectation(description: #function)

        sut.firstLoad(HomeViewController()) {
            XCTAssertTrue(sut.dataSourceElements() == 0)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func testPresenterGetNewDataSuccess() {
        let sut = HomePresenter(provider: stubProviderSuccess())

        let expectation = self.expectation(description: #function)

        sut.getNewData {
            XCTAssertTrue(sut.dataSourceElements() == 0)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func testPresenterGetNewDataFailure() {
        let sut = HomePresenter(provider: stubProviderFailure())

        let expectation = self.expectation(description: #function)

        sut.getNewData {
            XCTAssertTrue(sut.dataSourceElements() == 0)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func testPresenterGetOldDataSuccess() {
        let sut = HomePresenter(provider: stubProviderSuccess())

        let expectation = self.expectation(description: #function)

        sut.getOldData {
            XCTAssertTrue(sut.dataSourceElements() == 0)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func testPresenterGetOldDataFailure() {
        let sut = HomePresenter(provider: stubProviderFailure())

        let expectation = self.expectation(description: #function)

        sut.getOldData {
            XCTAssertTrue(sut.dataSourceElements() == 0)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func testFirstLoadAndGetOldData() {
        let sut = HomePresenter(provider: stubProviderSuccess())

        let expectation = self.expectation(description: #function)

        sut.firstLoad(HomeViewController()) {
            XCTAssertEqual(sut.dataSourceElements(), 10)
        }

        sut.getOldData {
            XCTAssertEqual(sut.dataSourceElements(), 20)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5.0, handler: nil)
    }

    func testFirstLoadAndGetNewData() {
        let sut = HomePresenter(provider: stubProviderSuccess())

        let expectation = self.expectation(description: #function)

        sut.firstLoad(HomeViewController()) {
            XCTAssertEqual(sut.dataSourceElements(), 10)
        }

        sut.getNewData {
            XCTAssertEqual(sut.dataSourceElements(), 20)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5.0, handler: nil)
    }
}
