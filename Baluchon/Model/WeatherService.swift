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
    
    private let fixedUrl = "https://query.yahooapis.com/v1/public/yql?q="
    private let dynamicUrl = "select item.condition, location.city from weather.forecast where woeid in (select woeid from geo.places(1) where text=\"new york\" or text=\"quimper\") and u='c'"

    private var task : URLSessionDataTask?
    
    private var weatherSession = URLSession(configuration: .default)
    
    init(weatherSession: URLSession) {
        self.weatherSession = weatherSession
    }
    
    func getWeather(callback: @escaping (Bool, Weather?) -> Void) {
        let finalUrl = fixedUrl + dynamicUrl.addingPercentEncoding(withAllowedCharacters: .alphanumerics)! + "&format=json"
        print(finalUrl)
        var request = URLRequest(url: URL(string: finalUrl)!)
        request.httpMethod = "GET"
        
        task?.cancel()
        task = weatherSession.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    callback(false, nil)
                    print("er1")
                    return
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(false, nil)
                    print("er2")
                    return
                }
                guard let weather = try? JSONDecoder().decode(Weather.self, from: data) else {
                    callback(false, nil)
                    print("erreur data")
                    return
                }
                callback(true, weather)
            }
        }
        task?.resume()
    }

//    func getWeatherIcon(code: String, completionHandler: @escaping ((WeatherIcon?) -> Void)) {
//        let iconUrl = URL(string: "http://l.yimg.com/a/i/us/we/52/\(code).gif")!
//        var request = URLRequest(url: iconUrl)
//        request.httpMethod = "GET"
//
//        task?.cancel()
//        task = weatherSession.dataTask(with: request) { (data, response, error) in
//            DispatchQueue.main.async {
//                guard let data = data, error == nil else {
//                    completionHandler(nil)
//                    print("er1")
//                    return
//                }
//                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
//                    completionHandler(nil)
//                    print("er2")
//                    return
//                }
//                let weatherIcon = WeatherIcon(weatherImage: data)
//                completionHandler(weatherIcon)
//            }
//        }
//        task?.resume()
//    }
}
