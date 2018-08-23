//
//  Language.swift
//  Baluchon
//
//  Created by Lei et Matthieu on 23/08/2018.
//  Copyright © 2018 Mattkee. All rights reserved.
//

import Foundation

struct Language: Decodable {
    let data: DataLanguage
}
struct DataLanguage: Decodable {
    let languages: [Languages]
}
struct Languages: Decodable {
    let language: String
    let name: String
}
