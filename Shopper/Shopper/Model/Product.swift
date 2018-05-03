//
//  Product.swift
//  Shopper
//
//  Created by Kaushik on 4/22/18.
//  Copyright © 2018 Kaushik. All rights reserved.
//

import Foundation

struct ProductsListResponse {
    let products: [Product]
    let totalProducts: Int
    let pageNumber: Int
    let pageSize: Int
    let status: Int
}

extension ProductsListResponse: Decodable {
    enum ProductsListResponseCodingKeys: String, CodingKey {
        case products       = "products"
        case totalProducts  = "totalProducts"
        case pageNumber     = "pageNumber"
        case pageSize       = "pageSize"
        case status         = "statusCode"
    }
    init(from decoder: Decoder) throws {
        let productsListResponseContainer   = try decoder.container(keyedBy: ProductsListResponseCodingKeys.self)
        products                            = try productsListResponseContainer.decode([Product].self, forKey: .products)
        totalProducts                       = try productsListResponseContainer.decode(Int.self, forKey: .totalProducts)
        pageNumber                          = try productsListResponseContainer.decode(Int.self, forKey: .pageNumber)
        pageSize                            = try productsListResponseContainer.decode(Int.self, forKey: .pageSize)
        status                              = try productsListResponseContainer.decode(Int.self, forKey: .status)
    }
}
struct Product {
    let id: String
    let name: String
    let shortDescription: String
    let longDescription: String
    let price: String
    let imageURL: String
    let reviewRating: Float
    let reviewCount: Int
    let inStock: Bool
}

extension Product: Decodable {
    enum ProductCodingKeys: String, CodingKey {
        case id                 = "productId"
        case name               = "productName"
        case shortDescription   = "shortDescription"
        case longDescription    = "longDescription"
        case price              = "price"
        case imageURL           = "productImage"
        case reviewRating       = "reviewRating"
        case reviewCount        = "reviewCount"
        case inStock            = "inStock"
    }
    
    init(from decoder: Decoder) throws {
        let productContainer    = try decoder.container(keyedBy: ProductCodingKeys.self)
        id                      = try productContainer.decode(String.self, forKey: .id)
        name                    = try productContainer.decode(String.self, forKey: .name)
        shortDescription        = try productContainer.decodeIfPresent(String.self, forKey: .shortDescription) ?? ""
        longDescription         = try productContainer.decodeIfPresent(String.self, forKey: .longDescription) ?? ""
        price                   = try productContainer.decode(String.self, forKey: .price)
        imageURL                = try productContainer.decodeIfPresent(String.self, forKey: .imageURL) ?? ""
        reviewRating            = try productContainer.decodeIfPresent(Float.self, forKey: .reviewRating) ?? 0.0
        reviewCount             = try productContainer.decodeIfPresent(Int.self, forKey: .reviewCount) ?? 0
        inStock                 = try productContainer.decodeIfPresent(Bool.self, forKey: .inStock) ?? false
    }
    
}
