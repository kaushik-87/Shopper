//
//  ProductsDetailsViewController.swift
//  Shopper
//
//  Created by Kaushik on 4/25/18.
//  Copyright © 2018 Kaushik. All rights reserved.
//

import UIKit

/// This viewController has a container view which loads the content of the pageviewcontroller.
/// UIPageViewController is used to handle the swipe left and swipe right to navigate between the products
class ProductsDetailsViewController: UIViewController {

    var productDetailsViewModel: ProductsDetailViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = kViewControllerTitle
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// Hands a tailored data model off to the embed-segue container views.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.destination {
        case let pvc as ProductsPageViewController:
            pvc.productDetailsViewModel = productDetailsViewModel
        default:
            break
        }
    }

}

