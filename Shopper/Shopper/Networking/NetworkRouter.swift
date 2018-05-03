//
//  NetworkRouter.swift
//  Shopper
//
//  Created by Kaushik on 4/22/18.
//  Copyright © 2018 Kaushik. All rights reserved.
//

import Foundation

enum Environment {
    case qa
    case production
}

/// Request protocol which defines the parameters which are required to construct a URLRequest.
/// 1. baseURL
/// 2. method - HTTPMethod
/// 3. path - to be append to the base URL
/// 4. headers - Key value pairs
/// 5. body
protocol Request {
    var baseURL: URL { get }
    var method: HTTPMethod { get }
    var path: String { get }
    var headers: [String: String]? { get }
    var parameters: [String: Any]? { get }
    var body: Data? { get }
}

/// Enum values for different HTTPMethod
public enum HTTPMethod: String {
    case get        = "GET"
    case post       = "POST"
    case put        = "PUT"
    case patch      = "PATCH"
    case delete     = "DELETE"
}

public typealias TaskCompletion = (_ data: Data?,_ response: URLResponse?,_ error: Error?)->()

/// Protocol method which is required to implement the request and response.
protocol NetworkRouter: class {
    func sendRequest( request: Request, completion: @escaping TaskCompletion)
}

/// NetworkRequestDispatcher which uses the URLSession and task to perform the network communication.
/// We can use any other for of communication like Alamorfire.
final class NetworkRequestDispatcher: NetworkRouter {
    private var task: URLSessionTask?

    /// Actual communication implementation using URLSession
    func sendRequest(request: Request, completion: @escaping TaskCompletion) {
        let session = URLSession.shared
        do {
            let request = try self.buildRequest(from: request)
            task = session.dataTask(with: request, completionHandler: { data, response, error in
                completion(data, response, error)
            })
        }catch {
            completion(nil, nil, error)
        }
        self.task?.resume()
    }
    
    /// Constructs the URLRequest from the request objects.
    fileprivate func buildRequest(from request: Request) throws -> URLRequest {
        var urlRequest = URLRequest(url: request.baseURL.appendingPathComponent(request.path),
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 10.0)
        
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return urlRequest
    }
}
