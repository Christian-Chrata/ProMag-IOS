//
//  MultipartFormData.swift
//  PreTest
//
//  Created by Christian Wiradinata on 17/12/22.
//

import Foundation

public struct MultipartFormData {
    public enum Provider {
        case text(String)
        case data(Data)
        case number(Int)
        case boolean(Bool)
        
    }
    
    public let provider: Provider
    public let name: String
    public let filename: String?
    public let mimeType: String?
    
    public init (provider: Provider, name: String, filename: String? = nil, mimeType: String? = nil) {
        self.provider = provider
        self.name = name
        self.filename = filename
        self.mimeType = mimeType
    }
}
