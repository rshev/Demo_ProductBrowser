//
//  Product.swift
//  Example_ProductBrowser
//
//  Created by asdfgh1 on 11/06/2016.
//  Copyright © 2016 rshev. All rights reserved.
//

import Foundation
import Unbox

// conforming to Hashable protocol here to be able to be included in dictionaries (like in BagManager)
struct Product: Unboxable, Hashable {
    
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

    var hashValue: Int {
        return id
    }
    
}

// required to conform to Equatable protocol (which is required by Hashable protocol)
func ==(lhs: Product, rhs: Product) -> Bool {
    return lhs.id == rhs.id
}
