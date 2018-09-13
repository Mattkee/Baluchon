//
//  TranslateAPI.swift
//  Baluchon
//
//  Created by Lei et Matthieu on 29/08/2018.
//  Copyright © 2018 Mattkee. All rights reserved.
//

import Foundation

// MARK: - Translate API from Google
struct TranslateAPI: EndPointType {

    var body = [String:String]()
    var baseURL: URL {
        return URL(string: "https://translation.googleapis.com/language/translate")!
    }
    
    var path: String {
        return "/v2"
    }
    
    var httpMethod: HTTPMethod = .post
    
    var task: HTTPTask {
        
        return .requestParameters(bodyParameters: body, urlParameters: ["key":Constant.googleAPIKey])
    }
}
