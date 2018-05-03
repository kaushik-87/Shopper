//
//  ProductDetailViewController.swift
//  Shopper
//
//  Created by Kaushik on 4/30/18.
//  Copyright © 2018 Kaushik. All rights reserved.
//

import UIKit
import SDWebImage
class ProductViewController: UIViewController {
    
    // MARK: IBOutlets
    @IBOutlet weak var shortDescriptiontextView: UITextView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var longDescriptionTextView: UITextView!
    @IBOutlet weak var productInStock: UILabel!
    @IBOutlet weak var descriptionTitle: UILabel!
    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    
    // MARK:  variables
    var productViewModel: ProductViewModel?
    
    // MARK: ViewController methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = kViewControllerTitle
        // Do any additional setup after loading the view.
        //self.productName.text = "TestTile"
        productViewModel?.productName.bind {
            self.productName.text = $0
        }
        productViewModel?.productShortDescription.bind {
            self.shortDescriptiontextView.attributedText = $0
        }
        productViewModel?.productLongDescription.bind {
            self.longDescriptionTextView.attributedText = $0
        }
        productViewModel?.productPrice.bind {
            self.priceLabel.text = $0
        }
        productViewModel?.productImageURL.bind {
            self.productImageView.sd_setImage(with: $0) { (image, error, type, url) in
            }
        }
        productViewModel?.productInStock.bind {
            let inStock = ($0 != nil)
            self.productInStock.isHidden = !inStock
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}
