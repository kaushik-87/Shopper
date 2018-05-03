//
//  ProductViewModel.swift
//  Shopper
//
//  Created by Kaushik on 4/27/18.
//  Copyright © 2018 Kaushik. All rights reserved.
//

import Foundation

class ProductViewModel {
    
    private var product: Product
    var productName : Bind<String> = Bind("")
    var productPrice : Bind<String?> = Bind("")
    var productImageURL : Bind<URL?> = Bind(nil)
    var productReviewRating : Bind<String?> = Bind(nil)
    var productReviewCount : Bind<String?> = Bind(nil)
    var productInStock : Bind<Bool?> = Bind(true)
    var productShortDescription : Bind<NSAttributedString?> = Bind(nil)
    var productLongDescription : Bind<NSAttributedString?> = Bind(nil)
    
    init(product: Product) {
        
        self.product = product
        productName.value = product.name
        productPrice.value = self.product.price
        productShortDescription.value = self.product.shortDescription.convertHtml()
        productLongDescription.value = self.product.longDescription.convertHtml()
        if self.product.imageURL != "" {
            let imageURL = URL(string: kProductsListProductionBaseURL + self.product.imageURL)
            productImageURL.value = imageURL
        }
        
        let reviewRating = self.product.reviewRating 
        productReviewRating.value = "\(reviewRating)"
        let reviewCount = self.product.reviewCount 
        productReviewCount.value = "\(reviewCount)"
        productInStock.value = self.product.inStock
    }
}
