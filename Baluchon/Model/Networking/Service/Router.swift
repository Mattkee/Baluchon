//
//  Router.swift
//  Baluchon
//
//  Created by Lei et Matthieu on 28/08/2018.
//  Copyright © 2018 Mattkee. All rights reserved.
//

import Foundation

class Router<EndPoint: EndPointType, Objet: Decodable>: NetworkRouter {
    private var task: URLSessionTask?
    let networkManager = NetworkManager()

    func request(_ route: EndPoint,_ session: URLSession,_ objet: Objet.Type, completion: @escaping NetworkRouterCompletion) {

        do {
            let request = try self.buildRequest(from: route)
            task = session.dataTask(with: request, completionHandler: { data, response, error in
                guard error == nil else {
                    print("Please check your network connection.")
                    completion(nil,nil, error, nil)
                    return
                }
                guard let response = response as? HTTPURLResponse else {
                    print("Please check check your API documentation")
                    completion(nil,nil, error, nil)
                    return
                }
                let result = self.networkManager.handleNetworkResponse(response)
                switch result {
                case .success :
                    guard let responseData = data else {
                        print(NetworkResponse.noData.rawValue)
                        completion(nil, nil, error, nil)
                        return
                    }
                    guard let objet = try? JSONDecoder().decode(objet.self, from: responseData) else {
                        print(NetworkResponse.unableToDecode.rawValue)
                        completion(nil, nil, error, nil)
                        return
                    }
                    completion(data, response, error, objet)
                case . failure(let networkFailureError) :
                    print(networkFailureError)
                    completion(nil, nil, error, nil)
                }
            })
        } catch {
            completion(nil,nil, error, nil)
        }
        self.task?.resume()
    }
    func cancel() {
        self.task?.cancel()
    }

    fileprivate func buildRequest(from route: EndPoint) throws -> URLRequest {

        var request = URLRequest(url: route.baseURL.appendingPathComponent(route.path), cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0)

        request.httpMethod = route.httpMethod.rawValue
        do {
            switch route.task {
//            case .request:
//                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            case .requestParameters(let bodyParameters, let urlParameters):
                try self.configureParameters(bodyParameters: bodyParameters, urlParameters: urlParameters, request: &request)
//            case .requestParametersAndHeaders(let bodyParameters, let urlParameters, let additionalHeaders):
//                self.addAdditionalHeaders(additionalHeaders, request: &request)
//                try self.configureParameters(bodyParameters: bodyParameters, urlParameters: urlParameters, request: &request)
            }
            return request
        } catch {
            throw error
        }
    }

    fileprivate func configureParameters(bodyParameters: Parameters?, urlParameters: Parameters?, request: inout URLRequest) throws {
        do {
            if let bodyParameters = bodyParameters {
                try JSONParameterEncoder.encode(urlRequest: &request, with: bodyParameters)
            }
            if let urlParameters = urlParameters {
                try URLParameterEncoder.encode(urlRequest: &request, with: urlParameters)
            }
        } catch {
            throw error
        }
    }

//    fileprivate func addAdditionalHeaders(_ additionalHeaders: HTTPHeaders?, request: inout URLRequest) {
//        guard let headers = additionalHeaders else { return }
//        for (key, value) in headers {
//            request.setValue(value, forHTTPHeaderField: key)
//        }
//    }
}
