//
//  NetworkState.swift
//  MOSAT
//
//  Created by Christian Wiradinata on 17/12/22.
//

import Foundation

enum NetworkState<T> {
    case loading
    case success(T)
    case failed(String)
}
