//
//  weatherImage.swift
//  Baluchon
//
//  Created by Lei et Matthieu on 20/08/2018.
//  Copyright © 2018 Mattkee. All rights reserved.
//

import UIKit

class weatherImage: UIView {
    
    var imageElement: String = "0" {
        didSet {
            setImage(imageElement)
        }
    }

    func setImage(_ imageElementCode: String) {
        switch imageElementCode {
        case "0", "2":
            let image = #imageLiteral(resourceName: "wind")
        case "1", "3", "4", "37", "38", "39", "45", "47":
            let image = #imageLiteral(resourceName: "storm")
        case "5", "6", "7", "13", "14", "15", "16", "17", "18", "41", "42", "43", "46":
            let image = #imageLiteral(resourceName: "snowing")
        case "8", "9", "10", "11", "12", "35", "40":
            let image = #imageLiteral(resourceName: "rain")
        case "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29":
            let image = #imageLiteral(resourceName: "cloud")
        case "31", "34":
            let image = #imageLiteral(resourceName: "half-moon")
        case "32", "33", "36":
            let image = #imageLiteral(resourceName: "sunny")
        default:
            let image = #imageLiteral(resourceName: "sun")
        }
    }
}
