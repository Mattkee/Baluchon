//
//  Weather.swift
//  Baluchon
//
//  Created by Lei et Matthieu on 16/08/2018.
//  Copyright © 2018 Mattkee. All rights reserved.
//

import Foundation

struct Weather: Decodable {
    let query: Query
}
struct Query: Decodable {
    let results: Results
}
struct Results: Decodable {
    let channel: [Channel]
}
struct Channel: Decodable {
    let location: Location
    let item: Item
}
struct Location: Decodable {
    let city: String
}
struct Item: Decodable {
    let condition: Condition
}
struct Condition: Decodable {
    let code: String
    let temp: String
    let text: String
}
