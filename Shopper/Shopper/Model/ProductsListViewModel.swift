//
//  ProductsListViewModel.swift
//  Shopper
//
//  Created by Kaushik on 4/25/18.
//  Copyright © 2018 Kaushik. All rights reserved.
//

import Foundation

// protocol method which we use to tell the coordinator to navigate to next screen.
protocol ProductsListModelDelegate {
    func didSelectViewModel(viewModel: ProductViewModel, productsList: [ProductViewModel])
}

class ProductsListViewModel {
    
    private var productsList: [ProductViewModel] = [ProductViewModel]()
    private var initialPageNumber = 0
    private var currentPageNumber = 0
    private var canFetchMoreItems = true
    
    var productsListDegelate: ProductsListModelDelegate?
    var productsService: ProductsService?
    
    // intializer which can take the product services.
    init(productsService: ProductsService) {
        self.productsService = productsService
    }
    
    // closures which communicates back to the viewcontroller to update the UI
    var reloadView: (()->())?
    var showAlert: ((_ title: String, _ message: String)->())?
    var loadMoreItems: ((_ startIndex: Int, _ endIndex: Int)->())?
    
    // fetch the products for the pagenumber and size of the page
    private func fetchProducts(pageNumber:Int, pageSize: Int) {
        
        self.productsService?.fetchProducts(page: pageNumber, pageSize: pageSize) { [weak self] (products, totalNumberOfItems, pageNumber, error) in
            
            if error != nil {
                print(error?.localizedDescription ?? "")
                self?.showAlert?("Network Error", "Could not connect to the server. Please try again later.")
                return
            }
            
            guard let products = products else {
                print("Error")
                self?.showAlert?("Products Error", "Failed to get the product list. Please try again later.")
                return
            }
            
            // if the pageNumber is 1, which means intial page.
            // then we can tell the viewcontroller to load the entire list.
            if pageNumber == 1 {
                var viewModels = [ProductViewModel]()
                for product in products {
                    viewModels.append(ProductViewModel(product: product))
                    print(product.name)
                }
                self?.productsList = viewModels
                self?.reloadView?()

            } else {
                // Else if the pagenumber is not the first then we need calculate startIndex and endIndex which is necessary to load the rows one by one instead of loadig the entire tableview.
                let startIndex = self?.productsList.count
                for product in products {
                    self?.productsList.append(ProductViewModel(product: product))
                    print(product.name)
                }
                let endIndex = self?.productsList.count
                self?.loadMoreItems?(startIndex ?? 0,endIndex ?? 0)
            }
            
            self?.currentPageNumber = pageNumber ?? 0
            if let totalItems = totalNumberOfItems,
                let count = self?.productsList.count {
                self?.canFetchMoreItems = (count < totalItems) ? true : false
            }
        }
    }
    
    // fetch products
    func fetchProducts() {
        self.fetchProducts(pageNumber: 1, pageSize: 10)
    }
    
    // fetch nextpage
    func fetchNextPage() {
        if self.canFetchMoreItems == true {
            self.fetchProducts(pageNumber: currentPageNumber+1, pageSize: 10)
        }
    }
    
    // number of items
    func numberOfItems() -> Int {
        return productsList.count 
    }
    
    // item at Index
    func itemAtIndex(index: Int) -> ProductViewModel {
        return productsList[index]
    }
    
    // once the user selects an item in the list
    func didSelectItemAtIndex(index: Int){
        let viewModel = productsList[index]
        self.productsListDegelate?.didSelectViewModel(viewModel: viewModel, productsList: productsList)
    }
}
