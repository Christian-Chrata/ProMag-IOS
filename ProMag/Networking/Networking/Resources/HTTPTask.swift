//
//  HTTPTask.swift
//  PreTest
//
//  Created by Christian Wiradinata on 17/12/22.
//

import Foundation

public enum HTTPTask {
    case request
    case requestParameters(parameters: [String: Any], encoding: ParameterEncoding)
    case requestCompositeParameters(bodyParameters: [String: Any], bodyEncoding: ParameterEncoding, urlParameters: [String: Any])
    case uploadMultipart(multipartFormData: [MultipartFormData])
    case uploadCompositeMultipart(multipartFormData: [MultipartFormData], urlParameters: [String:Any])
}
