//
//  Constant.swift
//  Baluchon
//
//  Created by Lei et Matthieu on 22/08/2018.
//  Copyright © 2018 Mattkee. All rights reserved.
//

import Foundation

struct Constant {
    struct WeatherConstant {
        private let fixedYahooUrl = "https://query.yahooapis.com/v1/public/yql?q="
        private let baseQueryUrl = "select item.condition, location.city from weather.forecast where woeid in (select woeid from geo.places(1) where text="
        private let endQueryUrl = ") and u='c'"
        private let endUrl = "&format=json"
        
        func prepareFinalUrl(_ allCity: [String]) -> URL {
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
            let finalQueryText = baseQueryUrl + text + endQueryUrl
            let dynamicYahooUrl = finalQueryText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
            let yahooUrl = URL(string: "\(fixedYahooUrl)\(dynamicYahooUrl)\(endUrl)")
            return yahooUrl!
        }
        
        static func setImage(_ imageElementCode: String) -> String {
            switch imageElementCode {
            case "0", "2":
                return "wind"
            case "1", "3", "4", "37", "38", "39", "45", "47":
                return "storm"
            case "5", "6", "7", "13", "14", "15", "16", "17", "18", "41", "42", "43", "46":
                return "snowing"
            case "8", "9", "10", "11", "12", "35", "40":
                return "rain"
            case "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29":
                return "cloud"
            case "31", "34":
                return "half-moon"
            case "32", "33", "36":
                return "sunny"
            default:
                return "sun"
            }
        }
    }
}
