//
//  URLParameterEncoder.swift
//  Baluchon
//
//  Created by Lei et Matthieu on 28/08/2018.
//  Copyright © 2018 Mattkee. All rights reserved.
//

import Foundation

public struct URLParameterEncoder: ParameterEncoder {
    public static func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
        guard let url = urlRequest.url else { throw NetworkError.missingURL }
        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), !parameters.isEmpty {

            urlComponents.queryItems = [URLQueryItem]()
            
            for (key, value) in parameters {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                urlComponents.queryItems?.append(queryItem)
            }
            urlRequest.url = urlComponents.url
        }

        if urlRequest.value(forHTTPHeaderField: "Content-type") == nil {
            urlRequest.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        }
    }
}
