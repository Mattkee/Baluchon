//
//  EndPointType.swift
//  Baluchon
//
//  Created by Lei et Matthieu on 28/08/2018.
//  Copyright © 2018 Mattkee. All rights reserved.
//

import Foundation

protocol EndPointType {
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
}
