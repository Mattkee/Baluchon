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

    // MARK: - Properties
    private let changeAPI = ChangeAPI()
    private let moneyAPI = MoneyAPI()    
    private let changeRouter = Router<ChangeAPI>()
    private let moneyRouter = Router<MoneyAPI>()

    private var changeSession = URLSession(configuration: .default)
    private var moneySession = URLSession(configuration: .default)

    init(changeSession: URLSession = URLSession(configuration: .default), moneySession: URLSession = URLSession(configuration: .default)) {
        self.changeSession = changeSession
        self.moneySession = moneySession
    }
}

// MARK: - Calculs
extension ChangeService {
    func changeMoney(changeNeed: Double, numberNeedToConvert: String, moneySelectedValueForOneEuro: Double) -> Double {
        var number: Double
        if numberNeedToConvert.last == "." {
            number = Double(numberNeedToConvert + "0")!
        } else {
            guard (Double(numberNeedToConvert) != nil) else {
                return 0
            }
            number = Double(numberNeedToConvert)!
        }
        var result : Double
        if moneySelectedValueForOneEuro == 1.0 {
            result = number * changeNeed
        } else {
            let numberToConvert = number / moneySelectedValueForOneEuro
            result = numberToConvert * changeNeed
        }
        return result
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
// MARK: - Network Call
extension ChangeService {
    func getChange(callback: @escaping (Bool, Change?, Money?) -> Void) {
        changeRouter.request(changeAPI, changeSession) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    callback(false, nil, nil)
                    return
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(false, nil, nil)
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
    }

    private func getMoney(completionHandler: @escaping ((Money?) -> Void)) {
        moneyRouter.request(moneyAPI, moneySession) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    completionHandler(nil)
                    return
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    completionHandler(nil)
                    return
                }
                do {
                    let money = try JSONDecoder().decode(Money.self, from: data)
                    completionHandler(money)
                } catch {
                    completionHandler(nil)
                }
            }
        }
    }
}
