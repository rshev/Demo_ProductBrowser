//
//  ProductCollectionViewCell.swift
//  Example_ProductBrowser
//
//  Created by asdfgh1 on 12/06/2016.
//  Copyright © 2016 rshev. All rights reserved.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var spinnerView: UIActivityIndicatorView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        setImage(nil)
        setOutline(false)
        priceLabel.text = nil
    }
    
    func setImage(image: UIImage?) {
        imageView.image = image
        _ = image == nil ? spinnerView.startAnimating() : spinnerView.stopAnimating()
    }
    
    func setOutline(value: Bool) {
        imageView.layer.borderWidth = value ? 3 : 0
        imageView.layer.borderColor = UIColor.yellowColor().CGColor
    }
    
}
