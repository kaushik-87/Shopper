//
//  ProductsDetailViewModel.swift
//  Shopper
//
//  Created by Kaushik on 4/25/18.
//  Copyright © 2018 Kaushik. All rights reserved.
//

import Foundation
/// This class has all the functions and logic necessary to support navigation
/// betweeen the products in the details screen.
class ProductsDetailViewModel {
    
    private var currentViewModel: ProductViewModel?
    private var productsList: [ProductViewModel]?
    private var currentIndex = 0
    
    /// initialize the viewmodel and calculate the current index of the viewModel
    init(productDetailVM: ProductViewModel, inList: [ProductViewModel]) {
        
        self.currentViewModel = productDetailVM
        self.productsList = inList
        
        if let i = inList.index(where: { $0 === productDetailVM }) {
            self.currentIndex = i
        }
    }
    
    /// Find the index of the viewModel
    private func indexOf(productViewModel: ProductViewModel) -> Int? {
        
        if let i = productsList?.index(where: { $0 === productViewModel }) {
            return i
        }
        
        return nil
    }

    // current viewModel
    func getCurentViewModel() -> ProductViewModel? {
        
        return self.productsList?[self.currentIndex]
    }
    
    // previous viewModel
    func getPreviousProduct() -> ProductViewModel? {
        
        guard let list = self.productsList else {
            return nil
        }
        
        if self.currentIndex > 0 {
            let index = self.currentIndex-1
            return list[index]
        }
        
        return nil
    }
    
    // next viewModel
    func getNextProduct() -> ProductViewModel? {
        
        guard let list = self.productsList else {
            return nil
        }
       
        if self.currentIndex < list.count-1 {
            let index = self.currentIndex+1
            return list[index]
        }
        
        return nil
    }
    
    // update the current index whenever the view is loaded completly.
    func didFinishLoadingVC(detailViewController: ProductViewController) {
        
        guard let viewModel = detailViewController.productViewModel else {
            return
        }
        
        if let index = indexOf(productViewModel: viewModel) {
            self.currentIndex = index
        }
    }
}
