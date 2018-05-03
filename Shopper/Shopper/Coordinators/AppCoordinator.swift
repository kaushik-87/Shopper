//
//  AppCoordinator.swift
//  Shopper
//
//  Created by Kaushik on 4/25/18.
//  Copyright © 2018 Kaushik. All rights reserved.
//

protocol Coordinator {
    func start()
}

import UIKit

/// Coordinator class is responsible for handling the app flow.
/// Coordinators implement the protocol start() which is the place where we configure the next flow.
class AppCoordinator: Coordinator {
    
    // we need the main window object
    var window: UIWindow?
    
    // lazy loading the navigationController 
    lazy var navigationController: UINavigationController = {
        let navigationController = UINavigationController()
        return navigationController
    }()
    
    init(window: UIWindow) {
        
        self.window = window
        
        self.window?.makeKeyAndVisible()
        
        self.window?.rootViewController = navigationController
        
    }
    
    func start() {
        // Here we create the productsServuce and pass it to the List cooordinator.
        let productsService = ProductsService()
        
        let productsListCoordinator = ProductsListCoordinator(productsService: productsService)
        
        productsListCoordinator.start()
        
        // Make sure we have the view controller before setting it to the navigation controller.
        guard let productsListVC = productsListCoordinator.viewController else {
            fatalError("could not initialize the products list view controlller")
        }
        
        self.navigationController.viewControllers = [productsListVC] as [UIViewController]
    }
}


