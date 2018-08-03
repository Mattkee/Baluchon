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
    private static let moneyUrl = URL(string: "http://data.fixer.io/api/symbols?access_key=d08ec4ef9bde66e8a89fafb3527c76f7")!

    private var task : URLSessionDataTask?

    private var changeSession = URLSession(configuration: .default)
    
    init(changeSession: URLSession) {
        self.changeSession = changeSession
    }

    func getChange(callback: @escaping (Bool, Change?, Money?) -> Void) {
        var request = URLRequest(url: ChangeService.changeUrl)
        request.httpMethod = "GET"

        task?.cancel()
        task = changeSession.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    callback(false, nil, nil)
                    print("er1")
                    return
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(false, nil, nil)
                    print("er2")
                    return
                }
                guard let change = try? JSONDecoder().decode(Change.self, from: data) else {
                    callback(false, nil, nil)
                    return
                }
                self.getMoney { (money) in
                    guard let money = money else {
                        callback(false, nil, nil)
                        return
                    }
                    callback(true, change, money)
                }
            }
        }
        task?.resume()
    }
    func getMoney(completionHandler: @escaping ((Money?) -> Void)) {
        var request = URLRequest(url: ChangeService.moneyUrl)
        request.httpMethod = "GET"
        
        task?.cancel()
        task = changeSession.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    completionHandler(nil)
                    print("er1")
                    return
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    completionHandler(nil)
                    print("er2")
                    return
                }
                do {
                    let money = try JSONDecoder().decode(Money.self, from: data)
                    completionHandler(money)
                } catch {
                    completionHandler(nil)
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
    func searchMoney(moneyName: String, moneyData: Money) -> String {
        for (abreviation, name) in moneyData.symbols {
            if moneyName == name {
                return abreviation
            }
        }
        return ""
    }
}
