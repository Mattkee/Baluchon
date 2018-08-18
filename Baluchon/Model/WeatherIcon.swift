//
//  WeatherIcon.swift
//  Baluchon
//
//  Created by Lei et Matthieu on 16/08/2018.
//  Copyright © 2018 Mattkee. All rights reserved.
//

import Foundation

struct WeatherIcon: Decodable {
    var weatherImage: Data
    
    init(weatherImage: Data) {
        self.weatherImage = weatherImage
    }
}
