//
//  APIClient.swift
//  Shopper
//
//  Created by Kaushik on 4/21/18.
//  Copyright © 2018 Kaushik. All rights reserved.
//
import Foundation


/// ProductsService  is the service layer which talks to the Network communication
/// Keeping the separate Network layer helps in unit testing the code.
/// 
struct ProductsService {
    // Setting the environment.
    static let environment: Environment = .production
    
    // We need a apiClient object which sends the request and handles the response.
    // This is the object which implements the NetworkRouter protocol.
    // Right now apiClient is accessible, so that we can set the mock networkRouter during the testing.
    var apiClient: NetworkRouter = NetworkRequestDispatcher()
    
    func fetchProducts(page: Int, pageSize: Int, completion: @escaping (_ products: [Product]?, _ totalNumberOfItems: Int?, _ pageNumber: Int?, _ error: ProductsServiceError? )->()) {
        
        // sendRequest and process the response.
        // Get the request object from the productEndPoints enum. 
        apiClient.sendRequest(request: ProductEndpoints.productsList(pageNumger: page, pageSize: pageSize)) { (data, response, error) in
            
            // In case of error send back to the caller by adding the Service layer error object.
            if error != nil {
                completion(nil, nil, nil, ProductsServiceError.network)
                return
            }
            
            if let response = response as? HTTPURLResponse {
                // Check whether we have a valid response
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    
                    // Process data only if we have the success response.
                    guard let responseData = data else {
                        completion(nil, nil, nil, ProductsServiceError.noData)
                        return
                    }
                    do {
                        print(responseData)
                        let jsonData = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)
                        print(jsonData)
                        let apiResponse = try JSONDecoder().decode(ProductsListResponse.self, from: responseData)
                        completion(apiResponse.products, apiResponse.totalProducts, apiResponse.pageNumber, nil)
                    }catch {
                        
                        // Send the parsing error to the caller
                        print(error)
                        completion(nil, nil, nil, ProductsServiceError.unableToDecode)
                    }
                    
                case .failure(let error):
                    completion(nil,nil, nil, error)
                }
                
            }
        }
    }
    
    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> NetworkResult{
        /// Check for the proper status code of the HTTPURLResponse object before processing the result.
        switch response.statusCode {
        case 200...299: return .success
        default: return .failure(ProductsServiceError.failed)
        }
    }
}

///
/// Network result enum which will be either success or failure.
enum NetworkResult {
    case success
    case failure(ProductsServiceError)
}


/// Enum values along with the localized description.
enum ProductsServiceError: Error {
    case network
    case noData
    case unableToDecode
    case badRequest
    case failed
    var localizedDescription: String {
        switch self {
        case .network:
            return kNetworkServerError
        case .noData:
            return kNetworkNoDataError
        case .badRequest:
            return kNetworkBadRequestError
        case .failed:
            return kNetworkFailedError
        case .unableToDecode:
            return kNetworkUnableToDecodeError
        }
    }
}
