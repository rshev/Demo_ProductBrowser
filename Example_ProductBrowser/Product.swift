//
//  Product.swift
//  Example_ProductBrowser
//
//  Created by asdfgh1 on 11/06/2016.
//  Copyright © 2016 rshev. All rights reserved.
//

import Foundation
import Unbox

struct Product: Unboxable {
    
    let id: Int
    let title: String
    let brand: String
    let formattedPrice: String
    let imageUrl: NSURL
    
    var details: ProductDetails?
    
    init(unboxer: Unboxer) {
        id = unboxer.unbox("ProductId")
        title = unboxer.unbox("Title")
        brand = unboxer.unbox("Brand")
        formattedPrice = unboxer.unbox("CurrentPrice")
        let imageUrls: [NSURL] = unboxer.unbox("ProductImageUrl").flatMap { NSURL(string: $0) }
        if let imageUrl = imageUrls.first {
            self.imageUrl = imageUrl
        } else {
            // fail it if no image. tricky because it's not a failable initializer
            // limitation of Unbox: https://github.com/JohnSundell/Unbox/issues/33
            unboxer.failForKey("ProductImageUrl")
            self.imageUrl = NSURL()
        }
    }
    
    mutating func assignDetails(productDetails: ProductDetails) {
        details = productDetails
    }

}
