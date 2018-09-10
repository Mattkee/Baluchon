//
//  WeatherServiceTestCase.swift
//  BaluchonTests
//
//  Created by Lei et Matthieu on 30/08/2018.
//  Copyright © 2018 Mattkee. All rights reserved.
//

import XCTest
@testable import Baluchon

class WeatherServiceTestCase: XCTestCase {
    
    func testGetWeatherShouldPostFailedCallbackIfError() {
        // Given
        let weatherService = WeatherService(
            weatherSession: URLSessionFake(data: nil, response: nil, error: FakeWeatherResponseData.error))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        weatherService.getWeather(city: Constant.allCity) { (error, weather) in
            // Then
            XCTAssertNotNil(error)
            XCTAssertNil(weather)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetWeatherShouldPostFailedCallbackIfNoData() {
        // Given
        let weatherService = WeatherService(
            weatherSession: URLSessionFake(data: nil, response: nil, error: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        weatherService.getWeather(city: Constant.allCity) { (error, weather) in
            // Then
            XCTAssertNotNil(error)
            XCTAssertNil(weather)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetWeatherShouldPostFailedCallbackIfIncorrectResponse() {
        // Given
        let weatherService = WeatherService(
            weatherSession: URLSessionFake(
                data: FakeWeatherResponseData.weatherCorrectData,
                response: FakeWeatherResponseData.responseKO,
                error: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        weatherService.getWeather(city: Constant.allCity) { (error, weather) in
            // Then
            XCTAssertNotNil(error)
            XCTAssertNil(weather)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetWeatherShouldPostFailedCallbackIfIncorrectData() {
        // Given
        let weatherService = WeatherService(
            weatherSession: URLSessionFake(
                data: FakeWeatherResponseData.weatherIncorrectData,
                response: FakeWeatherResponseData.responseOK,
                error: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        weatherService.getWeather(city: Constant.allCity) { (error, weather) in
            // Then
            XCTAssertNotNil(error)
            XCTAssertNil(weather)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }

    func testGetWeatherShouldPosterrorCallbackIfNoErrorAndCorrectData() {
        // Given
        let weatherService = WeatherService(
            weatherSession: URLSessionFake(
                data: FakeWeatherResponseData.weatherCorrectData,
                response: FakeWeatherResponseData.responseOK,
                error: nil))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        weatherService.getWeather(city: Constant.allCity) { (error, weather) in
            // Then
            XCTAssertNil(error)
            XCTAssertNotNil(weather)
            
            let city = "New York"
            let code = "34"
            let temp = "26"
            let text = "Mostly Sunny"
            let cityTwo = "Quimper"
            let codeTwo = "26"
            let tempTwo = "16"
            let textTwo = "Cloudy"
            let cityThree = "Nantes"
            let codeThree = "26"
            let tempThree = "20"
            let textThree = "Cloudy"
            
            XCTAssertEqual(city, weather?.query.results.channel[0].location.city)
            XCTAssertEqual(code, weather?.query.results.channel[0].item.condition.code)
            XCTAssertEqual(temp, weather?.query.results.channel[0].item.condition.temp)
            XCTAssertEqual(text, weather?.query.results.channel[0].item.condition.text)
            XCTAssertEqual(cityTwo, weather?.query.results.channel[1].location.city)
            XCTAssertEqual(codeTwo, weather?.query.results.channel[1].item.condition.code)
            XCTAssertEqual(tempTwo, weather?.query.results.channel[1].item.condition.temp)
            XCTAssertEqual(textTwo, weather?.query.results.channel[1].item.condition.text)
            XCTAssertEqual(cityThree, weather?.query.results.channel[2].location.city)
            XCTAssertEqual(codeThree, weather?.query.results.channel[2].item.condition.code)
            XCTAssertEqual(tempThree, weather?.query.results.channel[2].item.condition.temp)
            XCTAssertEqual(textThree, weather?.query.results.channel[2].item.condition.text)
            expectation.fulfill()
        }
    }
    func testGetWeatherWithOneCityShouldPosterrorCallbackIfNoErrorAndCorrectData() {
        // Given
        let weatherService = WeatherService(
            weatherSession: URLSessionFake(
                data: FakeWeatherResponseData.weatherCorrectData,
                response: FakeWeatherResponseData.responseOK,
                error: nil))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        weatherService.getWeather(city: ["New York"]) { (error, weather) in
            // Then
            XCTAssertNil(error)
            XCTAssertNotNil(weather)
            expectation.fulfill()
        }
    }
    func testSetImageWithCode32WhenSetThenResultIsSunny() {
        let weatherService = WeatherService()
        let result = weatherService.setImage("32")

        XCTAssertEqual(result, "sunny")
    }
    func testSetImageWithCode0WhenSetThenResultIsWind() {
        let weatherService = WeatherService()
        let result = weatherService.setImage("0")
        
        XCTAssertEqual(result, "wind")
    }
    func testSetImageWithCode1WhenSetThenResultIsStorm() {
        let weatherService = WeatherService()
        let result = weatherService.setImage("1")
        
        XCTAssertEqual(result, "storm")
    }
    func testSetImageWithCode5WhenSetThenResultIsSnowing() {
        let weatherService = WeatherService()
        let result = weatherService.setImage("5")
        
        XCTAssertEqual(result, "snowing")
    }
    func testSetImageWithCode8WhenSetThenResultIsRain() {
        let weatherService = WeatherService()
        let result = weatherService.setImage("8")
        
        XCTAssertEqual(result, "rain")
    }
    func testSetImageWithCode20WhenSetThenResultIsCloud() {
        let weatherService = WeatherService()
        let result = weatherService.setImage("20")
        
        XCTAssertEqual(result, "cloud")
    }
    func testSetImageWithCode27WhenSetThenResultIsHalfMoon() {
        let weatherService = WeatherService()
        let result = weatherService.setImage("27")
        
        XCTAssertEqual(result, "half-moon")
    }
    func testSetImageWithCode50WhenSetThenResultIsSun() {
        let weatherService = WeatherService()
        let result = weatherService.setImage("50")
        
        XCTAssertEqual(result, "sun")
    }
}
