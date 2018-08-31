//
//  NetworkManager.swift
//  Baluchon
//
//  Created by Lei et Matthieu on 29/08/2018.
//  Copyright © 2018 Mattkee. All rights reserved.
//

import Foundation

struct NetworkManager {
    let fixerAPIKey = "d08ec4ef9bde66e8a89fafb3527c76f7"
    let googleAPIKey = "AIzaSyBsL5HR_zdFcFdqZWSTyHhu--xxMrI-gCw"
    let changeRouter = Router<ChangeAPI>()
    let moneyRouter = Router<MoneyAPI>()
    let weatherRouter = Router<WeatherAPI>()
    let translateRouter = Router<TranslateAPI>()
    let languageRouter = Router<LanguageAPI>()

//    func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String>{
//        switch response.statusCode {
//        case 200...299: return .success
//        case 401...500: return .failure(NetworkResponse.authenticationError.rawValue)
//        case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
//        case 600: return .failure(NetworkResponse.outdated.rawValue)
//        default: return .failure(NetworkResponse.failed.rawValue)
//        }
//    }
}
//
//enum NetworkResponse:String {
//    case success
//    case authenticationError = "You need to be authenticated first."
//    case badRequest = "Bad request"
//    case outdated = "The url you requested is outdated."
//    case failed = "Network request failed."
//    case noData = "Response returned with no data to decode."
//    case unableToDecode = "We could not decode the response."
//}
//
//enum Result<String>{
//    case success
//    case failure(String)
//}
