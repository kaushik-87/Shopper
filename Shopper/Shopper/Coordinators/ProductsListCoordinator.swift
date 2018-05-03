//
//  ProductsListCoordinator.swift
//  Shopper
//
//  Created by Kaushik on 4/25/18.
//  Copyright © 2018 Kaushik. All rights reserved.
//

import Foundation
import UIKit

class ProductsListCoordinator: Coordinator {

    weak var viewController: ProductsListViewController?
    private let productsService: ProductsService
    
    // Products list coordinator initialized witth the products service
    init(productsService: ProductsService) {
        
        self.productsService = productsService
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        viewController = storyboard.instantiateViewController(withIdentifier: "ProductsListViewController") as? ProductsListViewController
    }
    
    
    func start() {
        
        viewController?.productsListViewModel = ProductsListViewModel(productsService: self.productsService)
        
        viewController?.productsListViewModel?.productsListDegelate = self
    }

}

// Handle the viewModel delegate to perform the navigation
extension ProductsListCoordinator: ProductsListModelDelegate {
    
    // This method is called when the user taps on one of the product from the list.
    func didSelectViewModel(viewModel: ProductViewModel, productsList: [ProductViewModel]) {
        
        // Create the productsDetail coordinator and pass on the viewModel and the list.
        let productsDetailsCoordinator = ProductsDetailCoordinator()
        productsDetailsCoordinator.start()
        
        if let detailsViewController = productsDetailsCoordinator.viewController {
            detailsViewController.productDetailsViewModel = ProductsDetailViewModel(productDetailVM: viewModel, inList: productsList)
            viewController?.navigationController?.pushViewController(detailsViewController, animated: true)
        }
    }
}
