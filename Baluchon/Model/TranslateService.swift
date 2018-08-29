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
    private let networkManager = NetworkManager()

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
        networkManager.translateRouter.request(translateAPI, translateSession) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    callback(false, nil)
                    print("er1")
                    return
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(false, nil)
                    print("er2")
                    return
                }
                guard let translate = try? JSONDecoder().decode(Translate.self, from: data) else {
                    callback(false, nil)
                    return
                }
                callback(true, translate)
            }
        }
    }

    // MARK: - Language network Call
    func getLanguage(completionHandler: @escaping (Bool, Language?) -> Void) {

        languageAPI.body = createLanguageBodyRequest()
        networkManager.languageRouter.request(languageAPI, languageSession) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    completionHandler(false, nil)
                    print("er1")
                    return
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    completionHandler(false, nil)
                    print("er2")
                    return
                }
                do {
                    let language = try JSONDecoder().decode(Language.self, from: data)
                    completionHandler(true, language)
                } catch {
                    completionHandler(false, nil)
                    print("er3")
                }
            }
        }
    }
}
