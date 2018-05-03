//
//  ProductsDetailCoordinator.swift
//  Shopper
//
//  Created by Kaushik on 4/25/18.
//  Copyright © 2018 Kaushik. All rights reserved.
//

import Foundation
import UIKit

class ProductsDetailCoordinator: Coordinator {

    weak var viewController: ProductsDetailsViewController?

    func start() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        self.viewController = storyboard.instantiateViewController(withIdentifier: "ProductsDetailsViewController") as? ProductsDetailsViewController
    }
}
