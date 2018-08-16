//
//  Weather.swift
//  Baluchon
//
//  Created by Lei et Matthieu on 16/08/2018.
//  Copyright © 2018 Mattkee. All rights reserved.
//

import Foundation

struct Weather: Decodable {
    let location : String
    let code: String
    let temp: String
    let text: String
}
