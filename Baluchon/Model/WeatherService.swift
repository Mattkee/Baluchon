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

    private var task : URLSessionDataTask?
    
    private var weatherSession = URLSession(configuration: .default)
    
    init(weatherSession: URLSession) {
        self.weatherSession = weatherSession
    }
    
    func getWeather(city: [String], callback: @escaping (Bool, Weather?) -> Void) {

        let Url = Constant.WeatherConstant().prepareFinalUrl(city)
        var request = URLRequest(url: Url)
        request.httpMethod = "GET"
        
        task?.cancel()
        task = weatherSession.dataTask(with: request) { (data, response, error) in
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
        task?.resume()
    }
}
