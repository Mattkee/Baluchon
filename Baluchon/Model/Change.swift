//
//  Change.swift
//  Baluchon
//
//  Created by Lei et Matthieu on 26/07/2018.
//  Copyright © 2018 Mattkee. All rights reserved.
//

import Foundation

struct Change {
    var base : String
    var rates : [String: Double]

    init(base: String, rates: [String: Double]) {
        self.base = base
        self.rates = rates
    }
}
