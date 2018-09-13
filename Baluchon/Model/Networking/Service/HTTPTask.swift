//
//  HTTPTask.swift
//  Baluchon
//
//  Created by Lei et Matthieu on 28/08/2018.
//  Copyright © 2018 Mattkee. All rights reserved.
//

import Foundation

// MARK: - Manages some type of request
public enum HTTPTask {
    case requestParameters(bodyParameters: Parameters?, urlParameters: Parameters?)
}
