//
//  NetworkRouter.swift
//  Baluchon
//
//  Created by Lei et Matthieu on 28/08/2018.
//  Copyright © 2018 Mattkee. All rights reserved.
//

import Foundation

public typealias NetworkRouterCompletion = (_ error: String?,_ object: Any?)->()

// MARK: - NetworkRouter protocol for Network Call
protocol NetworkRouter: class {
    associatedtype EndPoint: EndPointType
    associatedtype Object: Decodable

    func request(_ route: EndPoint,_ session: URLSession, _ object: Object.Type, completion: @escaping NetworkRouterCompletion)
    func cancel()
}
