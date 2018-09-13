//
//  WeatherAPI.swift
//  Baluchon
//
//  Created by Lei et Matthieu on 29/08/2018.
//  Copyright © 2018 Mattkee. All rights reserved.
//

import Foundation

// MARK: - Weather API from Yahoo
struct WeatherAPI: EndPointType {
    var bodyText = ""

    var baseURL: URL {
        return URL(string: "https://query.yahooapis.com/v1/public")!
    }
    
    var path: String {
        return "/yql"
    }
    
    var httpMethod: HTTPMethod = .get
    
    var task: HTTPTask {
        let q = bodyText
        return .requestParameters(bodyParameters: nil, urlParameters: ["q":q, "format":"json"])
    }
}
