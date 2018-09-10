//
//  Router.swift
//  Baluchon
//
//  Created by Lei et Matthieu on 28/08/2018.
//  Copyright © 2018 Mattkee. All rights reserved.
//

import Foundation

class Router<EndPoint: EndPointType, Object: Decodable>: NetworkRouter {
    private var task: URLSessionTask?
    let networkManager = NetworkManager()

    func request(_ route: EndPoint,_ session: URLSession,_ object: Object.Type, completion: @escaping NetworkRouterCompletion) {

        do {
            let request = try self.buildRequest(from: route)
            task = session.dataTask(with: request) { (data, response, error) in
                guard error == nil else {
                    print("Please check your network connection.")
                    completion(CustomerDisplayError.network.rawValue, nil)
                    return
                }
                self.responseManagement(data, response, object) { (error, object) in
                    completion(error, object)
                }
            }
        } catch {
            completion(CustomerDisplayError.update.rawValue, nil)
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
            case .requestParameters(let bodyParameters, let urlParameters):
                try self.configureParameters(bodyParameters: bodyParameters, urlParameters: urlParameters, request: &request)
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

    fileprivate func responseManagement(_ data: Data?,_ response: URLResponse?,_ object: Object.Type, completion: @escaping NetworkRouterCompletion) {

        guard let response = response as? HTTPURLResponse else {
            print("Please check check your API documentation")
            completion(CustomerDisplayError.update.rawValue, nil)
            return
        }
        let result = self.networkManager.handleNetworkResponse(response)
        switch result {
        case .success :
            dataManagement(data, object) { (error, object) in
                completion(nil, object)
            }
        case . failure(let networkFailureError) :
            print(networkFailureError)
            completion(CustomerDisplayError.update.rawValue, nil)
            return
        }
    }

    fileprivate func dataManagement(_ data: Data?,_ object: Object.Type, completion: @escaping NetworkRouterCompletion) {
        guard let responseData = data else {
            print(NetworkResponse.noData.rawValue)
            completion(CustomerDisplayError.update.rawValue, nil)
            return
        }
        guard let object = try? JSONDecoder().decode(object.self, from: responseData) else {
            print(NetworkResponse.unableToDecode.rawValue)
            completion(CustomerDisplayError.update.rawValue, nil)
            return
        }
        completion(nil, object)
    }
}
