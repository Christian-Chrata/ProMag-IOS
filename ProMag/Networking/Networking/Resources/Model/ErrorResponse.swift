//
//  ErrorResponse.swift
//  Networking
//
//  Created by Christian Wiradinata on 17/12/22.
//

import Foundation

enum ErrorType {
    case `default`
    case object
    case unknown
}

struct ErrorResponse: Decodable {
    let error: Error
    
    struct Error: Decodable {
        let code: Int?
        let errors: [Error]
        var type: ErrorType = .unknown
        
        struct Error: Codable {
            let param: String
            let messages: [String]
        }
        
        private enum CodingKeys: String, CodingKey {
            case code
            case errors
        }
        
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            code = try values.decodeIfPresent(Int.self, forKey: .code)
            if let message = try? values.decodeIfPresent([String].self, forKey: .errors) {
                type = .default
                errors = [Error(param: "", messages: message)]
            } else if let error = try? values.decodeIfPresent([Error].self, forKey: .errors) {
                type = .object
                errors = error
            } else {
                type = .unknown
                errors = []
            }
        }
    }
}
