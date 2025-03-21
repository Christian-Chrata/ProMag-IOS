//
//  NetworkManager.swift
//  PreTest
//
//  Created by Christian Wiradinata on 17/12/22.
//

import UIKit

public struct NetworkManager {
    public static var instance: NetworkManager = {
        let manager = NetworkManager()
        return manager
    }()
    public var router: Router = {
        let router = Router(with: Production())
        return router
    }()
    private let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        jsonDecoder.dateDecodingStrategy = .iso8601
        return jsonDecoder
    }()
    
    private init() {}
    
    @discardableResult
    public func requestObject(_ t: EndPointType, completion: @escaping (Result<Bool, NetworkError>) -> Void) -> String {
        return router.request(t) { (data, response, error) in
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(.certificationError))
                return
            }
            switch self.handleNetworkResponse(response) {
            case .success:
                if let data = data, error == nil {
                    switch checkStatus(data: data) {
                    case .success:
                        do {
                            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
                            print(json ?? "Empty")
                        } catch {
                            print(error.localizedDescription)
                        }
                        completion(.success(true))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let err):
                if let error = error as NSError?, error.domain == NSURLErrorDomain && error.code != NSURLErrorCancelled {
                    completion(.failure(NetworkError.unknown))
                    return
                } else {
                    switch err {
                    case .authenticationError:
                        completion(.failure(NetworkError.authenticationError))
                    case .badRequest:
                        completion(.failure(NetworkError.badRequest))
                    default:
                        if let data = data {
                            let result = self.decode(with: data, c: ErrorResponse.self)
                            switch result {
                            case .success(let object):
                                let message = object.error
                                    .errors.map { (error) -> String in
                                        return error.param + " " + error.messages.joined(separator: ", ")
                                    }.joined(separator: ", ")
                                completion(.failure(NetworkError.softError(message: message)))
                            case .failure(let error):
                                print("Url:", response.url?.absoluteString ?? "nil")
                                print("Status code:", response.statusCode)
                                completion(.failure(error))
                            }
                        }
                    }
                }
            }
        }
    }
    
    @discardableResult
    public func requestObject<C: Decodable>(_ t: EndPointType, c: C.Type, completion: @escaping (Result<C, NetworkError>) -> Void) -> String {
        return router.request(t) { (data, response, error) in
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(.certificationError))
                return
            }
            switch self.handleNetworkResponse(response) {
            case .success:
                if let data = data, error == nil {
                    let result = self.decode(with: data, c: c)
                    switch result {
                    case .success(let object):
                        completion(.success(object))
                    case .failure(let error):
                        print("Url:", response.url?.absoluteString ?? "nil")
                        print("Status code:", response.statusCode)
                        completion(.failure(error))
                    }
                }
            case .failure(let err):
                if let error = error as NSError?, error.domain == NSURLErrorDomain && error.code != NSURLErrorCancelled {
                    completion(.failure(NetworkError.unknown))
                    return
                } else {
                    switch err {
                    case .authenticationError:
                        completion(.failure(NetworkError.authenticationError))
                    case .badRequest:
                        completion(.failure(NetworkError.badRequest))
                    default:
                        if let data = data {
                            let result = self.decode(with: data, c: ErrorResponse.self)
                            switch result {
                            case .success(let object):
                                let message = object.error
                                    .errors.map { (error) -> String in
                                        return error.param + " " + error.messages.joined(separator: ", ")
                                    }.joined(separator: ", ")
                                completion(.failure(NetworkError.softError(message: message)))
                            case .failure(let error):
                                print("Url:", response.url?.absoluteString ?? "nil")
                                print("Status code:", response.statusCode)
                                completion(.failure(error))
                            }
                        }
                    }
                }
            }
        }
    }
    
    public func requestMock<C: Decodable>(_ t: EndPointType, c: C.Type, completion: @escaping (Result<C, NetworkError>) -> Void) {
        let result = self.decode(with: t.sampleData, c: c)
        switch result {
        case .success(let object):
            completion(.success(object))
        case .failure(let error):
            let json = try? JSONSerialization.jsonObject(with: t.sampleData, options: []) as? [String : Any]
            print("JSON: \(json ?? [:])")
            print("Status code:", error.description)
            completion(.failure(error))
        }
    }
    
    public func cancel() {
        router.cancel()
    }
    
    public func cancel(with url: String) {
        router.cancel(with: url)
    }
    
    private func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<Bool, NetworkError> {
        switch response.statusCode {
        case 200...299: return .success(true)
        case 403: return .failure(NetworkError.authenticationError)
        case 500...599: return .failure(NetworkError.badRequest)
        default: return .failure(NetworkError.failed)
        }
    }
    
    private func decode<C: Decodable>(with data: Data, c: C.Type) -> Result<C, NetworkError> {
       
        
        switch checkStatus(data: data) {
        case .success:
            do {
                let data = try self.jsonDecoder.decode(c.self, from: data)
                return .success(data)
             } catch let DecodingError.dataCorrupted(context) {
                print(context)
                return .failure(NetworkError.unableToDecode)
             } catch let DecodingError.keyNotFound(key, context) {
                print("Key '\(key)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
                return .failure(NetworkError.unableToDecode)
            } catch let DecodingError.valueNotFound(value, context) {
                print("Value '\(value)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
                return .failure(NetworkError.unableToDecode)
            } catch let DecodingError.typeMismatch(type, context)  {
                print("Type '\(type)' mismatch:", context.debugDescription)
                print("codingPath:", context.codingPath)
                return .failure(NetworkError.unableToDecode)
             } catch {
                return .failure(NetworkError.unknown)
             }
        case .failure(let error):
            return .failure(error)
        }
        
    }
    
    private func checkStatus(data: Data) -> Result<Void, NetworkError> {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
            if let statusCode = json?["statuscode"] as? Int, let message = json?["message"] as? String {
                switch statusCode {
                case 200:
                    return .success(())
                case 400, 401:
                    return .failure(.softError(message: message))
                default:
                    return .failure(.unknown)
                }
            } else {
                return .failure(.unableToDecode)
            }
        } catch {
            return .failure(.unableToDecode)
        }
    }
    
   
}

