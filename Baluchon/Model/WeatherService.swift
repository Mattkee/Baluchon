//
//  WeatherService.swift
//  Baluchon
//
//  Created by Lei et Matthieu on 16/08/2018.
//  Copyright © 2018 Mattkee. All rights reserved.
//

import Foundation

class WeatherService {

    // MARK: - Properties
    private var task : URLSessionDataTask?
    
    private let weatherRouter = Router<WeatherAPI>()
    var weatherAPI = WeatherAPI()
    private var weatherSession = URLSession(configuration: .default)
    
    init(weatherSession: URLSession = URLSession(configuration: .default)) {
        self.weatherSession = weatherSession
    }

    func prepareCityText(_ allCity: [String]) -> String {
        var text = ""

        for city in allCity {
            if allCity[0] == city {
                text = "'\(city)'"
            } else {
                text = text + "or text='\(city)'"
            }
        }
        if allCity.count == 1 {
            text = text + "or text='tourch'"
        }
        let q = "select item.condition, location.city from weather.forecast where woeid in (select woeid from geo.places(1) where text=\(text)) and u='c'"
        return q
    }

    // MARK: - Weather Network Call
    func getWeather(city: [String], callback: @escaping (Bool, Weather?) -> Void) {
        weatherAPI.bodyText = prepareCityText(city)
        weatherRouter.request(weatherAPI, weatherSession) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    callback(false, nil)
                    return
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(false, nil)
                    return
                }
                guard let weather = try? JSONDecoder().decode(Weather.self, from: data) else {
                    callback(false, nil)
                    return
                }
                callback(true, weather)
            }
        }
    }
}
