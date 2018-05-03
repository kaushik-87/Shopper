//
//  ProductsListViewController.swift
//  Shopper
//
//  Created by Kaushik on 4/25/18.
//  Copyright © 2018 Kaushik. All rights reserved.
//

import UIKit
import Foundation

class ProductsListViewController: UIViewController {
    
    // MARK: IBOutlets
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var productsListCollectionView: UICollectionView!
    
    // MARK: Variables
    private var isMoreDataLoading = false
    private let refreshControl = UIRefreshControl()
    
    var productsListViewModel: ProductsListViewModel?

    // MARK: Viewcontroller methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        productsListCollectionView.refreshControl = refreshControl
        productsListCollectionView.register(UINib(nibName: "ProductCell", bundle: nil), forCellWithReuseIdentifier: "ProductCell")
        
        initializeViewModel()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Initialize methods
    private func initializeViewModel() {
        
        // Here we set all the closures needed to perform UI actions based on the viewmodel updates.
        // Handling the reload collection view once the new list is fetched
        productsListViewModel?.reloadView = { [weak self] in
            DispatchQueue.main.async {
                self?.productsListCollectionView.reloadData()
                self?.activityIndicator.stopAnimating()
                self?.activityIndicator.isHidden = true
                self?.refreshControl.endRefreshing()
            }
        }
        
        // We need to just load the additional rows once the user scrolled to the bottom of the list.
        // Below code adds the number of rows based on the startIndex and endIndex provided by the viewModel
        productsListViewModel?.loadMoreItems = { [weak self] (startIndex, endIndex) in
            self?.isMoreDataLoading = false
            var indexPaths = [IndexPath]()
            for index in startIndex..<endIndex {
                indexPaths.append(IndexPath(item: index, section: 0))
            }
            DispatchQueue.main.async {
                self?.productsListCollectionView.insertItems(at: indexPaths)
            }
        }
        
        //Show alert
        productsListViewModel?.showAlert = { [weak self] (title, message) in
            DispatchQueue.main.async {
                self?.showAlertFor(title: title, message: message)
            }
            
        }
        
        // as Part of the initialization we fetch the products.
        productsListViewModel?.fetchProducts()
        
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
    }

    
    @objc func refreshControlAction(_ refreshControl: UIRefreshControl) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { [weak self] in
            self?.productsListViewModel?.fetchProducts()
        }
    }
    
}

// MARK: Extensions
/// Handle the alert controllers
extension ProductsListViewController {
    func showAlertFor(title: String, message: String) {
        DispatchQueue.main.async { [weak self] in
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
            alert.addAction(okAction)
            self?.present(alert, animated: true)
            self?.activityIndicator.isHidden = true
            self?.activityIndicator.stopAnimating()
            self?.refreshControl.endRefreshing()
        }
    }
}

// MARK: -  UICollectionViewDelegate methods
extension ProductsListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.productsListViewModel?.didSelectItemAtIndex(index: indexPath.row)
    }
}

// MARK: - UICollectionViewDatasource methods
extension ProductsListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.productsListViewModel?.numberOfItems() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as? ProductCell else {
            fatalError("Cell could not be initialized")
        }
        cell.productViewModel = self.productsListViewModel?.itemAtIndex(index: indexPath.row)
        return cell
    }
}

// MARK: - ScrollviewDelegate
extension ProductsListViewController : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading){
            let scrollViewContentHeight = self.productsListCollectionView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - self.productsListCollectionView.bounds.size.height
            if(scrollView.contentOffset.y > scrollOffsetThreshold && self.productsListCollectionView.isDragging) {
                isMoreDataLoading = true
                productsListViewModel?.fetchNextPage()
            }
        }
        
    }
}
