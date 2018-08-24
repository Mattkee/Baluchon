//
//  FakeChangeResponseData.swift
//  BaluchonTests
//
//  Created by Lei et Matthieu on 24/08/2018.
//  Copyright © 2018 Mattkee. All rights reserved.
//

import Foundation

class FakeChangeResponseData {
    static let responseOK = HTTPURLResponse(
        url: URL(string: "https://openclassrooms.com")!,
        statusCode: 200, httpVersion: nil, headerFields: [:])!
    
    static let responseKO = HTTPURLResponse(
        url: URL(string: "https://openclassrooms.com")!,
        statusCode: 500, httpVersion: nil, headerFields: [:])!
    
    class ChangeError: Error {}
    static let error = ChangeError()
    
    static var changeCorrectData: Data? {
        let bundle = Bundle(for: FakeChangeResponseData.self)
        let url = bundle.url(forResource: "Change", withExtension: "json")!
        return try! Data(contentsOf: url)
    }
    static let changeIncorrectData = "erreur".data(using: .utf8)!
}
