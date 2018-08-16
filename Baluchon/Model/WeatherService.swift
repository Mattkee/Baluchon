//
//  WeatherService.swift
//  Baluchon
//
//  Created by Lei et Matthieu on 16/08/2018.
//  Copyright © 2018 Mattkee. All rights reserved.
//

import Foundation

class WeatherService {
    static var shared = WeatherService()
    private init() {}

    private static let WeatherUrl = URL(string: "https://query.yahooapis.com/v1/public/yql?q=select%20item.condition,location.city%20from%20weather.forecast%20where%20woeid%20in%20(select%20woeid%20from%20geo.places(1)%20where%20text%3D%22New%20York%22)%20and%20u%20%3D'c'&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys")!

    private var task : URLSessionDataTask?
    
    private var weatherSession = URLSession(configuration: .default)
    
    init(weatherSession: URLSession) {
        self.weatherSession = weatherSession
    }
    
    func getWeather(callback: @escaping (Bool, Weather?, WeatherIcon?) -> Void) {
        var request = URLRequest(url: WeatherService.WeatherUrl)
        request.httpMethod = "GET"
        
        task?.cancel()
        task = weatherSession.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    callback(false, nil, nil)
                    print("er1")
                    return
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(false, nil, nil)
                    print("er2")
                    return
                }
                guard let weather = try? JSONDecoder().decode(Weather.self, from: data) else {
                    callback(false, nil, nil)
                    return
                }
                self.getWeatherIcon(weather: weather) { (weatherIcon) in
                    guard let weatherIcon = weatherIcon else {
                        callback(false, nil, nil)
                        return
                    }
                    callback(true, weather, weatherIcon)
                }
            }
        }
        task?.resume()
    }
    func getWeatherIcon(weather: Weather, completionHandler: @escaping ((WeatherIcon?) -> Void)) {
        let weatherNumber = weather.code
        let iconUrl = URL(string: "http://l.yimg.com/a/i/us/we/52/\(weatherNumber).gif")!
        var request = URLRequest(url: iconUrl)
        request.httpMethod = "GET"
        
        task?.cancel()
        task = weatherSession.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    completionHandler(nil)
                    print("er1")
                    return
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    completionHandler(nil)
                    print("er2")
                    return
                }
                do {
                    let weatherIcon = try JSONDecoder().decode(WeatherIcon.self, from: data)
                    completionHandler(weatherIcon)
                } catch {
                    completionHandler(nil)
                    print("er3")
                }
            }
        }
        task?.resume()
    }
}
