//
//  ProductsEndpoint.swift
//  Shopper
//
//  Created by Kaushik on 4/22/18.
//  Copyright © 2018 Kaushik. All rights reserved.
//

import Foundation

/// Enum which could hold all the different endpoints related to Products.
public enum ProductEndpoints {
    case productsList(pageNumger: Int, pageSize: Int)
}

/// Implements the Request protocol to provide all the necessary values required for the URLRequest.
extension ProductEndpoints: Request {
    
    // In each method we could return the values based on the endpoints enum.
    var parameters: [String : Any]? {
        return nil
    }
    
    var body: Data? {
        return nil
    }
    
    private var environmentBaseURL: String {
        switch ProductsService.environment {
        case .production:
            return kProductsListProductionBaseURL
        case .qa:
            // Just for the demo purpose
            return "https://walmartlabs-test.appspot.com/_ah/api/walmart/v1"
        }
    }
    var baseURL: URL {
        guard let baseURL = URL(string: environmentBaseURL) else {
            fatalError("Failed to construct Base URL")
        }
        return baseURL
    }
    
    var method: HTTPMethod {
        // We can decide based on the endpoints
        return .get
    }
    
    var path: String {
        // Return the path based on the endpoints.
        switch self {
        case .productsList(let pageNumber, let pageSize):
            return "/walmartproducts/\(pageNumber)/\(pageSize)"
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
}
