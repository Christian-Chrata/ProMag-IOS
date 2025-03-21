//
//  JsonConvert.swift
//  Networking
//
//  Created by Christian Wiradinata on 17/12/22.
//

import Foundation

extension Encodable {
    /// Converting object to postable JSON
   public func toJSONString(isSnakeCase: Bool = false) -> String {
        let encoder = JSONEncoder()
        if (isSnakeCase){
            encoder.keyEncodingStrategy = .convertToSnakeCase
        }
        let jsonData = try! encoder.encode(self)
        return String(data: jsonData, encoding: .utf8)!
        }
}

