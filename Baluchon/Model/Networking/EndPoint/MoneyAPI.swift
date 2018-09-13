//
//  MoneyAPI.swift
//  Baluchon
//
//  Created by Lei et Matthieu on 29/08/2018.
//  Copyright © 2018 Mattkee. All rights reserved.
//

import Foundation

// MARK: - Money API from Fixer.io
struct MoneyAPI: EndPointType {
    private let networkManager = NetworkManager()
    var baseURL: URL {
        return URL(string: "http://data.fixer.io")!
    }
    
    var path: String {
        return "/symbols"
    }
    
    var httpMethod: HTTPMethod = .get
    
    var task: HTTPTask {
        return .requestParameters(bodyParameters: nil, urlParameters: ["access_key":Constant.fixerAPIKey])
    }
}
