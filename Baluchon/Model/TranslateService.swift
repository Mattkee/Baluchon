//
//  TranslateService.swift
//  Baluchon
//
//  Created by Lei et Matthieu on 23/08/2018.
//  Copyright © 2018 Mattkee. All rights reserved.
//

import Foundation

class TranslateService {
    
    // MARK: - Properties
    private var translateAPI = TranslateAPI()
    private var languageAPI = LanguageAPI()
    let translateRouter = Router<TranslateAPI, Translate>()
    let languageRouter = Router<LanguageAPI, Language>()

    private var translateSession = URLSession(configuration: .default)
    private var languageSession = URLSession(configuration: .default)
    
    init(translateSession: URLSession = URLSession(configuration: .default), languageSession: URLSession = URLSession(configuration: .default)) {
        self.translateSession = translateSession
        self.languageSession = languageSession
    }
}

// MARK: - URL Management
extension TranslateService {
    private func createTranslateBodyRequest(textToTranslate: String, languageToTranslate: String, languageTranslated: String) -> [String:String] {
        
        return ["source":languageToTranslate, "target":languageTranslated, "q":textToTranslate, "format":"text"]
    }
    private func createLanguageBodyRequest() -> [String:String] {

        return ["target":"fr"]
    }
}

// MARK: - Network Call
extension TranslateService {
    // MARK: - Translate Network Call
    func getTranslate(textToTranslate: String, languageToTranslate: String, languageTranslated: String, callback: @escaping (Bool, Translate?) -> Void) {

        translateAPI.body = createTranslateBodyRequest(textToTranslate: textToTranslate, languageToTranslate: languageToTranslate, languageTranslated: languageTranslated)
        translateRouter.request(translateAPI, translateSession, Translate.self) { (data, response, error, object) in
            DispatchQueue.main.async {
                guard error == nil else {
                    callback(false, nil)
                    return
                }
                let translate = object as? Translate
                callback(true, translate)
            }
        }
    }

    // MARK: - Language network Call
    func getLanguage(completionHandler: @escaping (Bool, Language?) -> Void) {

        languageAPI.body = createLanguageBodyRequest()
        languageRouter.request(languageAPI, languageSession, Language.self) { (data, response, error, object) in
            DispatchQueue.main.async {
                guard error == nil else {
                    completionHandler(false, nil)
                    return
                }
                let language = object as? Language
                completionHandler(true, language)
            }
        }
    }
}
