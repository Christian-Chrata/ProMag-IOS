//
//  ContentType.swift
//  PreTest
//
//  Created by Christian Wiradinata on 17/12/22.
//

import Foundation

public enum ContentType: String {
    case json = "application/json"
    case multipart = "multipart/form-data"
}

public enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
    case deviceId = "device-id"
    case local = "Locale"
    case xDeviceToken = "X-Device-Token"
    case userGroup = "User-Group"
    case sessionToken = "X-Session-Token"
}
