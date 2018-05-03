//
//  ShopperTests.swift
//  ShopperTests
//
//  Created by Kaushik on 4/21/18.
//  Copyright © 2018 Kaushik. All rights reserved.
//

import XCTest
@testable import Shopper

class ShopperTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testService() {
        var prodService = ProductsService()
        prodService.apiClient = MockNetworkLayer()
        let expectation = XCTestExpectation(description: "products")
        prodService.fetchProducts(page: 1, pageSize: 10) { (products, pageNumber, totalItems, serviceError) in
            expectation.fulfill()
            
        }
        
        wait(for: [expectation], timeout: 100)
    }
    
}

///
/// Below code demonstrate how we can create our own Mock networklayer using NetworkRouter Protocol for unit testing.
/// And then set the mock network layer to the service.
/// We can add more tests by mocking different network scenarios.
///
class MockNetworkLayer: NetworkRouter {
    func sendRequest(request: Request, completion: @escaping TaskCompletion) {
        let errorTemp = NSError(domain:"network", code:500, userInfo:nil)
        completion(nil,nil,errorTemp)
    }
}

/// Creating a mock request object using Request protocol
class MockRequest: Request {
    var parameters: [String : Any]? {
        return nil
    }
    
    var body: Data? {
        return nil
    }
    
    private var environmentBaseURL: String {
        switch ProductsService.environment {
        case .production:
            return "https://mobile-tha-server.appspot.com"
        case .qa:
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
        return .get
    }
    
    var path: String {
            return "/walmartproducts/\(1)/\(10)"
    }
    
    var headers: [String : String]? {
        return nil
    }
}
