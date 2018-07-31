//
//  ChangeService.swift
//  Baluchon
//
//  Created by Lei et Matthieu on 26/07/2018.
//  Copyright © 2018 Mattkee. All rights reserved.
//

import Foundation

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
        
        task?.cancel()
        task = changeSession.dataTask(with: ChangeService.changeUrl) { (data, response, error) in
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
                guard let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                    let base = responseJSON!["base"] as? String,
                    let rate = responseJSON!["rate"] as? [String: Double] else {
                        callback(false, nil)
                        print("er3")
                        return
                }
                let change = Change(base: base, rate: rate)
                callback(true, change)
            }
        }
        task?.resume()
    }
    func changeMoney(changeNeed: Double, numberNeedToConvert: Double) -> Double {
        return numberNeedToConvert * changeNeed
    }
    func searchRate(chosenCurrency: String, rateData: Change) -> Double {
        return rateData.rate[chosenCurrency]!
    }
}
