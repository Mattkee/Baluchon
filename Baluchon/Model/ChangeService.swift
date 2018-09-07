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
    func changeMoney(_ moneyToConvertName: String, _ moneyConvertedName: String,_ valueNeedToConvert: String,_ change: Change,_ money: Money) -> Double {

        let abreviationOne = searchMoney(moneyName: moneyToConvertName, moneyData: money)
        let abreviationTwo = searchMoney(moneyName: moneyConvertedName, moneyData: money)
        let moneySelectedValueForOneEuro = change.rates[abreviationOne]!
        let currencyWeNeed = change.rates[abreviationTwo]!

        var number: Double
        guard (Double(valueNeedToConvert) != nil) else {
            return 0
        }
        number = Double(valueNeedToConvert)!
        var result : Double
        if moneySelectedValueForOneEuro == 1.0 {
            result = number * currencyWeNeed
        } else {
            let numberToConvert = number / moneySelectedValueForOneEuro
            result = numberToConvert * currencyWeNeed
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
    func getChange(callback: @escaping (String?, Change?, Money?) -> Void) {
        changeRouter.request(changeAPI, changeSession, Change.self) { (error, object) in
            DispatchQueue.main.async {
                guard error == nil else {
                    callback(error, nil, nil)
                    return
                }
                self.getMoney { (error, money) in
                    guard let money = money else {
                        callback(error, nil, nil)
                        return
                    }
                    let change = object as? Change
                    callback(nil, change, money)
                }
            }
        }
    }

    private func getMoney(completionHandler: @escaping (String?, Money?) -> Void) {
        moneyRouter.request(moneyAPI, moneySession, Money.self) { (error, object) in
            DispatchQueue.main.async {
                guard error == nil else {
                    completionHandler(error, nil)
                    return
                }
               let money = object as? Money
                completionHandler(nil, money)
            }
        }
    }
}
