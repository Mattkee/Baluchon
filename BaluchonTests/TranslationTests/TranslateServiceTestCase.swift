//
//  TranslateServiceTestCase.swift
//  BaluchonTests
//
//  Created by Lei et Matthieu on 30/08/2018.
//  Copyright © 2018 Mattkee. All rights reserved.
//

import XCTest
@testable import Baluchon

class TranslateServiceTestCase: XCTestCase {
    
    func testGetTranslateShouldPostFailedCallbackIfError() {
        // Given
        let translateService = TranslateService(
            translateSession: URLSessionFake(data: nil, response: nil, error: FakeTranslateResponseData.error))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translateService.getTranslate(textToTranslate: "Bienvenue en Bretagne", languageToTranslate: "Français", languageTranslated: "Anglais") { (error, translate) in
            // Then
            XCTAssertNotNil(error)
            XCTAssertNil(translate)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetTranslateShouldPostFailedCallbackIfNoData() {
        // Given
        let translateService = TranslateService(
            translateSession: URLSessionFake(data: nil, response: nil, error: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translateService.getTranslate(textToTranslate: "Bienvenue en Bretagne", languageToTranslate: "Français", languageTranslated: "Anglais") { (error, translate) in
            // Then
            XCTAssertNotNil(error)
            XCTAssertNil(translate)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetTranslateShouldPostFailedCallbackIfIncorrectResponse() {
        // Given
        let translateService = TranslateService(
            translateSession: URLSessionFake(data: FakeTranslateResponseData.translateCorrectData, response: FakeTranslateResponseData.responseKO, error: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translateService.getTranslate(textToTranslate: "Bienvenue en Bretagne", languageToTranslate: "Français", languageTranslated: "Anglais") { (error, translate) in
            // Then
            XCTAssertNotNil(error)
            XCTAssertNil(translate)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetTranslateShouldPostFailedCallbackIfIncorrectData() {
        // Given
        let translateService = TranslateService(
            translateSession: URLSessionFake(
                data: FakeTranslateResponseData.translateIncorrectData,
                response: FakeTranslateResponseData.responseOK,
                error: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translateService.getTranslate(textToTranslate: "Bienvenue en Bretagne", languageToTranslate: "Français", languageTranslated: "Anglais") { (error, translate) in
            // Then
            XCTAssertNotNil(error)
            XCTAssertNil(translate)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetTranslateShouldPosterrorCallbackIfNoErrorAndCorrectData() {
        // Given
        let translateService = TranslateService(
            translateSession: URLSessionFake(
                data: FakeTranslateResponseData.translateCorrectData,
                response: FakeTranslateResponseData.responseOK,
                error: nil))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translateService.getTranslate(textToTranslate: "Bienvenue en Bretagne", languageToTranslate: "Français", languageTranslated: "Anglais") { (error, translate) in
            // Then
            XCTAssertNil(error)
            XCTAssertNotNil(translate)
            
            let translatedText = "Welcome to Brittany"
            
            XCTAssertEqual(translatedText, translate?.data.translations[0].translatedText)
            expectation.fulfill()
        }
    }
    
    func testGetLanguageShouldPostFailedCallbackIfError() {
        // Given
        let translateService = TranslateService(
            languageSession: URLSessionFake(data: nil, response: nil, error: FakeLanguageResponseData.error))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translateService.getLanguage { (error, language) in
            // Then
            XCTAssertNotNil(error)
            XCTAssertNil(language)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetLanguageShouldPostFailedCallbackIfNoData() {
        // Given
        let translateService = TranslateService(
            languageSession: URLSessionFake(data: nil, response: nil, error: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translateService.getLanguage { (error, language) in
            // Then
            XCTAssertNotNil(error)
            XCTAssertNil(language)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetLanguageShouldPostFailedCallbackIfIncorrectResponse() {
        // Given
        let translateService = TranslateService(
            languageSession: URLSessionFake(data: FakeLanguageResponseData.languageCorrectData, response: FakeLanguageResponseData.responseKO, error: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translateService.getLanguage { (error, language) in
            // Then
            XCTAssertNotNil(error)
            XCTAssertNil(language)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetLanguageShouldPostFailedCallbackIfIncorrectData() {
        // Given
        let translateService = TranslateService(
            languageSession: URLSessionFake(
                data: FakeLanguageResponseData.languageIncorrectData,
                response: FakeLanguageResponseData.responseOK,
                error: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translateService.getLanguage { (error, language) in
            // Then
            XCTAssertNotNil(error)
            XCTAssertNil(language)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetLanguageShouldPosterrorCallbackIfNoErrorAndCorrectData() {
        // Given
        let translateService = TranslateService(
            languageSession: URLSessionFake(
                data: FakeLanguageResponseData.languageCorrectData,
                response: FakeLanguageResponseData.responseOK,
                error: nil))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translateService.getLanguage { (error, language) in
            // Then
            XCTAssertNil(error)
            XCTAssertNotNil(language)
            
            let languageOne = ["language": "af","name": "Afrikaans"]
            let languageTwo = ["language": "sq","name": "Albanais"]
            let languageThree = ["language": "de","name": "Allemand"]
            
            XCTAssertEqual(languageOne["name"], language?.data.languages[0].name)
            XCTAssertEqual(languageTwo["name"], language?.data.languages[1].name)
            XCTAssertEqual(languageThree["name"], language?.data.languages[2].name)
            expectation.fulfill()
        }
    }
}
