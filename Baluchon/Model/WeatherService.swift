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
    private var weatherAPI = WeatherAPI()
    private let networkManager = NetworkManager()

    private var weatherSession = URLSession(configuration: .default)

    init(weatherSession: URLSession = URLSession(configuration: .default)) {
        self.weatherSession = weatherSession
    }

    func setImage(_ imageElementCode: String) -> String {
        switch imageElementCode {
        case "0", "2":
            return "wind"
        case "1", "3", "4", "24", "37", "38", "39", "45", "47":
            return "storm"
        case "5", "6", "7", "13", "14", "15", "16", "17", "18", "41", "42", "43", "46":
            return "snowing"
        case "8", "9", "10", "11", "12", "35", "40":
            return "rain"
        case "20", "21", "22", "23", "26":
            return "cloud"
        case "27", "29", "31", "34":
            return "half-moon"
        case "32", "33", "36":
            return "sunny"
        default:
            return "sun"
        }
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
        networkManager.weatherRouter.request(weatherAPI, weatherSession) { (data, response, error) in
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
