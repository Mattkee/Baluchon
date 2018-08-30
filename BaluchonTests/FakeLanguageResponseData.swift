//
//  FakeLanguageResponseData.swift
//  BaluchonTests
//
//  Created by Lei et Matthieu on 30/08/2018.
//  Copyright © 2018 Mattkee. All rights reserved.
//

import Foundation

class FakeLanguageResponseData {
    static let responseOK = HTTPURLResponse(
        url: URL(string: "https://openclassrooms.com")!,
        statusCode: 200, httpVersion: nil, headerFields: [:])!
    
    static let responseKO = HTTPURLResponse(
        url: URL(string: "https://openclassrooms.com")!,
        statusCode: 500, httpVersion: nil, headerFields: [:])!
    
    class LanguageError: Error {}
    static let error = LanguageError()
    
    static var languageCorrectData: Data? {
        let bundle = Bundle(for: FakeLanguageResponseData.self)
        let url = bundle.url(forResource: "Language", withExtension: "json")!
        return try! Data(contentsOf: url)
    }
    static let languageIncorrectData = "erreur".data(using: .utf8)!
}
