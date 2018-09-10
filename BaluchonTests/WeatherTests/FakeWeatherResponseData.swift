//
//  FakeWeatherResponseData.swift
//  BaluchonTests
//
//  Created by Lei et Matthieu on 30/08/2018.
//  Copyright © 2018 Mattkee. All rights reserved.
//

import Foundation

class FakeWeatherResponseData {
    static let responseOK = HTTPURLResponse(
        url: URL(string: "https://openclassrooms.com")!,
        statusCode: 200, httpVersion: nil, headerFields: [:])!
    
    static let responseKO = HTTPURLResponse(
        url: URL(string: "https://openclassrooms.com")!,
        statusCode: 500, httpVersion: nil, headerFields: [:])!
    
    class WeatherError: Error {}
    static let error = WeatherError()
    
    static var weatherCorrectData: Data? {
        let bundle = Bundle(for: FakeWeatherResponseData.self)
        let url = bundle.url(forResource: "Weather", withExtension: "json")!
        return try! Data(contentsOf: url)
    }
    static let weatherIncorrectData = "erreur".data(using: .utf8)!
}
