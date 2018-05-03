//
//  ProductsViewController.swift
//  Shopper
//
//  Created by Kaushik on 4/30/18.
//  Copyright © 2018 Kaushik. All rights reserved.
//

import UIKit

class ProductsPageViewController: UIPageViewController {

    var productDetailsViewModel: ProductsDetailViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        dataSource = self
        delegate  = self
        
        // Install the first-presented view controller
        let firstVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductDetailViewController") as! ProductViewController
        firstVC.productViewModel = productDetailsViewModel?.getCurentViewModel()
        setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// MARK : UIPageViewController delegate methods
extension ProductsPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if (completed && finished) {
            
            // Once the view is loaded after the swipe, we need to update the current index in our viewModel
            // Get the viewModel from the currently loaded VC and pass it to detailsViewModel.
            if let viewControllers = pageViewController.viewControllers {
                if let currentViewController = viewControllers[0] as? ProductViewController {
                    productDetailsViewModel?.didFinishLoadingVC(detailViewController: currentViewController)
                }
            }
        }
    }
}

// MARK: - UIPageViewController datasource methods
extension ProductsPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        // get the prevProduct view model from detailsViewModel
        if let prevPoduct = productDetailsViewModel?.getPreviousProduct() {
            return detailViewController(viewModel: prevPoduct)
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        // get the nextProduct view model from detailsViewModel
        if let nextProduct = productDetailsViewModel?.getNextProduct() {
            return detailViewController(viewModel: nextProduct)
        }
        return nil
    }
}

// MARK: - Helper method
extension ProductsPageViewController {
    
    // instantiate the detailview controller and sets the viewModel
    func detailViewController(viewModel: ProductViewModel) -> ProductViewController {
        let productVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductDetailViewController") as! ProductViewController
        productVC.productViewModel = viewModel
        return productVC
    }
}
