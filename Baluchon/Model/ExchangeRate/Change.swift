//
//  Change.swift
//  Baluchon
//
//  Created by Lei et Matthieu on 26/07/2018.
//  Copyright © 2018 Mattkee. All rights reserved.
//

import Foundation

struct Change: Decodable {
    let base: String
    let rates: [String: Double]
}
