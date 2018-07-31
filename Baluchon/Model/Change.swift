//
//  Change.swift
//  Baluchon
//
//  Created by Lei et Matthieu on 26/07/2018.
//  Copyright © 2018 Mattkee. All rights reserved.
//

import Foundation

class Change {
    var base : String
    var rate : [String: Double]

    init(base: String, rate: [String: Double]) {
        self.base = base
        self.rate = rate
    }
}
