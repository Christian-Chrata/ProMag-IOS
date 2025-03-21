//
//  NetworkRouter.swift
//  PreTest
//
//  Created by Christian Wiradinata on 17/12/22.
//

import Foundation
import AuthManager

typealias NetworkRouterCompletion = (_ data: Data?,_ response: URLResponse?,_ error: Error?)->()

protocol NetworkRouter {
    func request(_ route: EndPointType, completion: @escaping NetworkRouterCompletion) -> String
    func cancel(with udid: String)
    func cancel()
}

public protocol EndPoint {
    var baseURL: URL { get }
    var header: [String:String]? { get }
}

public struct Production: EndPoint {
    public var baseURL: URL = {
        guard let url = URL(string: "https://emriszic.xyz/public/api") else { fatalError("baseURL could not be configured.")}
        return url
    }()
    
    public init() {}
    
    public var header: [String:String]? = {
        return [
            HTTPHeaderField.contentType.rawValue: ContentType.json.rawValue,
            HTTPHeaderField.acceptType.rawValue: ContentType.json.rawValue
        ]
    }()
}

public class Router: NSObject, URLSessionDelegate, NetworkRouter {
    private var task: [String:URLSessionTask] = [:]
    private lazy var session: URLSession = {
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 60.0
        sessionConfig.timeoutIntervalForResource = 60.0
        let session = URLSession(configuration: sessionConfig,
                   delegate: self,
                   delegateQueue: nil)
        return session
    }()
    private var endpoint: EndPoint!
    
    public init(with endpoint: EndPoint) {
        self.endpoint = endpoint
    }
    
    func request(_ route: EndPointType, completion: @escaping NetworkRouterCompletion) -> String {
        do {
            let request = try self.buildRequest(from: route)
            self.task[request.url!.absoluteString] = session.dataTask(with: request, completionHandler: { (data, response, error) in
                completion(data, response, error)
                if let response = (response as? HTTPURLResponse) {
                    NetworkLogger.log(response: response)
                }
            })
            self.task[request.url!.absoluteString]?.resume()
            return request.url!.absoluteString
        } catch {
            completion(nil, nil, error)
            fatalError()
        }
    }
    
    func cancel(with url: String) {
        task[url]?.cancel()
    }
    
    func cancel() {
        for t in task {
            t.value.cancel()
        }
    }
    
    fileprivate func buildRequest(from route: EndPointType) throws -> URLRequest {
        var request = URLRequest(url: endpoint.baseURL.appendingPathComponent(route.path),
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 10.0)
        request.httpMethod = route.httpMethod.rawValue
        request.timeoutInterval = TimeInterval(60)
        do {
            self.addAdditionalHeaders(endpoint.header, request: &request)
            switch route.task {
            case .request:
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.setValue( "Bearer \(AuthManager.shared.accessToken)", forHTTPHeaderField: "Authorization")
            case .requestParameters(let parameters, let encoding):
                try self.configureParameters(bodyParameters: parameters, bodyEncoding: encoding, urlParameters: nil, request: &request)
            case .requestCompositeParameters(let bodyParameters, let bodyEncoding, let urlParameters):
                try self.configureParameters(bodyParameters: bodyParameters, bodyEncoding: bodyEncoding, urlParameters: urlParameters, request: &request)
            case .uploadMultipart(let multipartFormData):
                try self.configureParameters(multipartFormData: multipartFormData, urlParameters: nil, request: &request)
                
            case .uploadCompositeMultipart(let multipartFormData, let urlParameters):
                try self.configureParameters(multipartFormData: multipartFormData, urlParameters: urlParameters, request: &request)
            }
            NetworkLogger.log(request: request)
            return request
        } catch {
            throw error
        }
    }
    
    fileprivate func configureParameters(multipartFormData: [MultipartFormData],
                                         urlParameters: [String:Any]?,
                                         request: inout URLRequest) throws {
        let boundary = "Boundary-\(UUID().uuidString)"
        var httpBody = Data()
        let linebreak = "\r\n"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        do {
            try ParameterEncoding.urlEncoding.encode(urlRequest: &request, bodyParameters: nil, urlParameters: urlParameters)
            for media in multipartFormData {
                httpBody.append(Data("--\(boundary + linebreak)".utf8))
                if let filename = media.filename {
                    httpBody.append(Data("Content-Disposition: form-data; name=\"\(media.name)\"; filename=\"\(filename)\"\(linebreak)".utf8))
                } else {
                    httpBody.append(Data("Content-Disposition: form-data; name=\"\(media.name)\"\(linebreak + linebreak)".utf8))
                }
                if let mimeType = media.mimeType {
                    httpBody.append(Data("Content-Type: \(mimeType + linebreak + linebreak)".utf8))
                }
                switch media.provider {
                case .data(let data):
                    httpBody.append(data)
                    httpBody.append(Data(linebreak.utf8))
                case .text(let text):
                    httpBody.append(Data("\(text + linebreak)".utf8))
                case .number(let int):
                    httpBody.append(Data("\(String(int) + linebreak)".utf8))
                case .boolean(let bool):
                    httpBody.append(Data("\(String(bool) + linebreak)".utf8))
                }
            }
            httpBody.append(Data("--\(boundary)--\(linebreak)".utf8))
            request.httpBody = httpBody
        } catch {
            throw error
        }
        request.setValue( "Bearer \(AuthManager.shared.accessToken)", forHTTPHeaderField: "Authorization")
    }
    
    fileprivate func configureParameters(bodyParameters: [String:Any]?,
                                         bodyEncoding: ParameterEncoding,
                                         urlParameters: [String:Any]?,
                                         request: inout URLRequest) throws {
        do {
            try bodyEncoding.encode(urlRequest: &request, bodyParameters: bodyParameters, urlParameters: urlParameters)
        } catch {
            throw error
        }
        request.setValue( "Bearer \(AuthManager.shared.accessToken)", forHTTPHeaderField: "Authorization")
    }
    
    fileprivate func addAdditionalHeaders(_ additionalHeaders: [String:String]?, request: inout URLRequest) {
        guard let headers = additionalHeaders else { return }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
}
