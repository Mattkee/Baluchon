//
//  TranslateService.swift
//  Baluchon
//
//  Created by Lei et Matthieu on 23/08/2018.
//  Copyright © 2018 Mattkee. All rights reserved.
//

import Foundation

class TranslateService {
    
    static var shared = TranslateService()
    private init() {}
    
    private static let translateUrl = URL(string: "https://translation.googleapis.com/language/translate/v2?key=AIzaSyBsL5HR_zdFcFdqZWSTyHhu--xxMrI-gCw")!
    private static let languageUrl = URL(string: "https://translation.googleapis.com/language/translate/v2/languages?key=AIzaSyBsL5HR_zdFcFdqZWSTyHhu--xxMrI-gCw")!
    
    private var task: URLSessionDataTask?
    
    private var translateSession = URLSession(configuration: .default)
    private var languageSession = URLSession(configuration: .default)
    
    init(translateSession: URLSession, languageSession: URLSession) {
        self.translateSession = translateSession
        self.languageSession = languageSession
    }
    private func createTranslateRequest(textToTranslate: String, languageToTranslate: String, languageTranslated: String) -> URLRequest {
        var request = URLRequest(url: TranslateService.translateUrl)
        request.httpMethod = "POST"

        let body = "target=\(languageTranslated)&source=\(languageToTranslate)&q=\(textToTranslate)"
        request.httpBody = body.data(using: .utf8)
        
        return request
    }
    private func createLanguageRequest() -> URLRequest {
        var request = URLRequest(url: TranslateService.languageUrl)
        request.httpMethod = "POST"
        
        let body = "target=fr"
        request.httpBody = body.data(using: .utf8)
        
        return request
    }
}

// MARK: - Network Call
extension TranslateService {
    func getTranslate(textToTranslate: String, languageToTranslate: String, languageTranslated: String, callback: @escaping (Bool, Translate?) -> Void) {
        let request = createTranslateRequest(textToTranslate: textToTranslate, languageToTranslate: languageToTranslate, languageTranslated: languageTranslated)

        task?.cancel()
        task = translateSession.dataTask(with: request) { (data, response, error) in
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
        task?.resume()
    }
    
    func getLanguage(completionHandler: @escaping (Bool, Language?) -> Void) {
        let request = createLanguageRequest()
        
        task?.cancel()
        task = translateSession.dataTask(with: request) { (data, response, error) in
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
        task?.resume()
    }
}
