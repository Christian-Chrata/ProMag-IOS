//
//  SingleResponse.swift
//  Networking
//
//  Created by Christian Wiradinata on 17/12/22.
//

import Foundation

public struct SingleResponse <T: Codable>: Codable {
    public let statuscode: Int
    public let message: String
    public let data: T
}

public struct RegisterResponse <T: Codable>: Codable {
    public let statuscode: Int
    public let message: String?
    public let errorMessage: ErrorMessage?
    public let data: T
    
    public struct ErrorMessage: Codable {
        public let userEmail: [String]?
    }
}

public struct EmptyData: Codable { }
