//
//  ProductCell.swift
//  Shopper
//
//  Created by Kaushik on 4/29/18.
//  Copyright © 2018 Kaushik. All rights reserved.
//

import UIKit
import SDWebImage

class ProductCell: UICollectionViewCell {

    // MARK: IBOutlets
    @IBOutlet weak var reviewDetails: UILabel!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    
    // MARK: Initialze view
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    // MARK: Setter
    var productViewModel: ProductViewModel? {
        didSet {
            DispatchQueue.main.async {
                self.productViewModel?.productName.bind{ [unowned self] in
                    self.productName.text = $0
                }
                self.productViewModel?.productPrice.bind{ [unowned self] in
                    self.productPrice.text = $0
                }
                self.productViewModel?.productImageURL.bind { [unowned self] in
                    self.productImage.sd_setImage(with: $0) { (image, error, type, url) in
                    }
                }
                self.productViewModel?.productReviewCount.bind { [unowned self] in
                    self.reviewDetails.text = "Reviews - \($0 ?? "")"
                }
            }
        }
    }

    // MARK: Init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
}
