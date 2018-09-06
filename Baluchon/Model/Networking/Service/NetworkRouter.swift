//
//  NetworkRouter.swift
//  Baluchon
//
//  Created by Lei et Matthieu on 28/08/2018.
//  Copyright © 2018 Mattkee. All rights reserved.
//

import Foundation

public typealias NetworkRouterCompletion = (_ data: Data?,_ response: URLResponse?,_ error: Error?,_ objet: Any?)->()

protocol NetworkRouter: class {
    associatedtype EndPoint: EndPointType
    associatedtype Objet: Decodable

    func request(_ route: EndPoint,_ session: URLSession, _ objet: Objet.Type, completion: @escaping NetworkRouterCompletion)
    func cancel()
}
