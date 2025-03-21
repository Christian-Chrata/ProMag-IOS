//
//  ViewState.swift
//  Common
//
//  Created by Christian Wiradinata on 17/12/22.
//

import Foundation
import Networking

public enum ViewState<T> {
    typealias data = T
    
    case loading
    case success(data: T)
    case error(error: NetworkError)
}
