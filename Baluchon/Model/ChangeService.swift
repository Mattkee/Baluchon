//
//  ChangeService.swift
//  Baluchon
//
//  Created by Lei et Matthieu on 26/07/2018.
//  Copyright © 2018 Mattkee. All rights reserved.
//

import Foundation

protocol DisplayAlert {
    func showAlert(title: String, message: String)
}

class ChangeService {
    static var shared = ChangeService()
    private init() {}

    private static let changeUrl = URL(string: "http://data.fixer.io/api/latest?access_key=d08ec4ef9bde66e8a89fafb3527c76f7")!

    private var task : URLSessionDataTask?

    private var changeSession = URLSession(configuration: .default)
    
    init(changeSession: URLSession) {
        self.changeSession = changeSession
    }

    func getChange(callback: @escaping (Bool, Change?) -> Void) {
        var request = URLRequest(url: ChangeService.changeUrl)
        request.httpMethod = "GET"

        task?.cancel()
        task = changeSession.dataTask(with: request) { (data, response, error) in
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
                do {
                   let change = try JSONDecoder().decode(Change.self, from: data)
                    callback(true, change)
                } catch {
                    callback(false, nil)
                    print("er3")
                }
            }
        }
        task?.resume()
    }
    func changeMoney(changeNeed: Double, numberNeedToConvert: String) -> Double {
        let number = Double(numberNeedToConvert)!
        return number * changeNeed
    }
}
