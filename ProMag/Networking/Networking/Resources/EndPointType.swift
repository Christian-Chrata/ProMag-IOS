//
//  EndPointType.swift
//  PreTest
//
//  Created by Christian Wiradinata on 17/12/22.
//

import Foundation

public protocol EndPointType {
    var path: String { get }
    var parameters: [String:Any]? { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
    var sampleData: Data { get }
}
