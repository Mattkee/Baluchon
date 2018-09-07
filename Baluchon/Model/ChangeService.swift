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
    private let changeRouter = Router<ChangeAPI, Change>()
    private let moneyRouter = Router<MoneyAPI, Money>()

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
        changeRouter.request(changeAPI, changeSession, Change.self) { (data, response, error, object) in
            DispatchQueue.main.async {
                guard error == nil else {
                    callback(false, nil, nil)
                    return
                }
                self.getMoney { (money) in
                    guard let money = money else {
                        callback(false, nil, nil)
                        return
                    }
                    let change = object as? Change
                    callback(true, change, money)
                }
            }
        }
    }

    private func getMoney(completionHandler: @escaping ((Money?) -> Void)) {
        moneyRouter.request(moneyAPI, moneySession, Money.self) { (data, response, error, object) in
            DispatchQueue.main.async {
                guard error == nil else {
                    completionHandler(nil)
                    return
                }
               let money = object as? Money
                completionHandler(money)
            }
        }
    }
}
