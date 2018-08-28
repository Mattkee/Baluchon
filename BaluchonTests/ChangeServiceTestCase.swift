//
//  ChangeServiceTestCase.swift
//  BaluchonTests
//
//  Created by Lei et Matthieu on 24/08/2018.
//  Copyright © 2018 Mattkee. All rights reserved.
//

import XCTest
@testable import Baluchon

class ChangeServiceTestCase: XCTestCase {
    
    func testGetChangeShouldPostFailedCallbackIfError() {
        // Given
        let changeService = ChangeService(
            changeSession: URLSessionFake(data: nil, response: nil, error: FakeChangeResponseData.error),
            moneySession: URLSessionFake(data: nil, response: nil, error: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        changeService.getChange { (success, change, money) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(change)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }

    func testGetChangeShouldPostFailedCallbackIfNoData() {
        // Given
        let changeService = ChangeService(
            changeSession: URLSessionFake(data: nil, response: nil, error: nil),
            moneySession: URLSessionFake(data: nil, response: nil, error: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        changeService.getChange { (success, change, money) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(change)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }

    func testGetChangeShouldPostFailedCallbackIfIncorrectResponse() {
        // Given
        let changeService = ChangeService(
            changeSession: URLSessionFake(
                data: FakeChangeResponseData.changeCorrectData,
                response: FakeChangeResponseData.responseKO,
                error: nil),
            moneySession: URLSessionFake(data: nil, response: nil, error: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        changeService.getChange { (success, change, money) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(change)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }

    func testGetChangeShouldPostFailedCallbackIfIncorrectData() {
        // Given
        let changeService = ChangeService(
            changeSession: URLSessionFake(
                data: FakeChangeResponseData.changeIncorrectData,
                response: FakeChangeResponseData.responseOK,
                error: nil),
            moneySession: URLSessionFake(data: nil, response: nil, error: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        changeService.getChange { (success, change, money) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(change)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
}
