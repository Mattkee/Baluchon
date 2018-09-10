//
//  FakeMoneyResponseData.swift
//  BaluchonTests
//
//  Created by Lei et Matthieu on 24/08/2018.
//  Copyright © 2018 Mattkee. All rights reserved.
//

import Foundation

class FakeMoneyResponseData {
    static let responseOK = HTTPURLResponse(
        url: URL(string: "https://openclassrooms.com")!,
        statusCode: 200, httpVersion: nil, headerFields: [:])!
    
    static let responseKO = HTTPURLResponse(
        url: URL(string: "https://openclassrooms.com")!,
        statusCode: 500, httpVersion: nil, headerFields: [:])!
    
    class MoneyError: Error {}
    static let error = MoneyError()
    
    static var moneyCorrectData: Data? {
        let bundle = Bundle(for: FakeMoneyResponseData.self)
        let url = bundle.url(forResource: "Money", withExtension: "json")!
        return try! Data(contentsOf: url)
    }
    static let moneyIncorrectData = "erreur".data(using: .utf8)!
}
