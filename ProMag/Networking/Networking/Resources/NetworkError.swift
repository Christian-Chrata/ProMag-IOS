//
//  NetworkError.swift
//  PreTest
//
//  Created by Christian Wiradinata on 17/12/22.
//

import Foundation

public enum NetworkError: Error {
    public enum AlertType {
        case success
        case failure
    }
    
    case authenticationError
    case badRequest
    case unableToDecode
    case missingURL
    case encodingFailed
    case failed
    case unknown
    case certificationError
    case softError(message: String)
    
    public var description: String {
        switch self {
        case .authenticationError:
            return "Akun anda sudah digunakan di perangkat lain, silahkan coba kembali sesaat lagi"
        case .badRequest:
            return "Bad Request"
        case .unableToDecode:
            return "Unable To Decode"
        case .missingURL:
            return "Missing URL"
        case .encodingFailed:
            return "Encoding Failed"
        case .failed:
            return "Failed"
        case .unknown:
            return "Unknown error"
        case .certificationError:
            return "Certification Error"
        case .softError(let message):
            return message
        }
    }
}
