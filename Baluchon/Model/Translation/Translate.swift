//
//  Translate.swift
//  Baluchon
//
//  Created by Lei et Matthieu on 23/08/2018.
//  Copyright © 2018 Mattkee. All rights reserved.
//

import Foundation

struct Translate: Decodable {
    let data: DataTranslate
}
struct DataTranslate: Decodable {
    let translations: [Translations]
}
struct Translations: Decodable {
    let translatedText: String
}
