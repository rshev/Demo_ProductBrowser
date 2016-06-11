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
    let imageUrls: [NSURL]
    
    init(unboxer: Unboxer) {
        id = unboxer.unbox("ProductId")
        title = unboxer.unbox("Title")
        brand = unboxer.unbox("Brand")
        formattedPrice = unboxer.unbox("CurrentPrice")
        imageUrls = unboxer.unbox("ProductImageUrl").flatMap { NSURL(string: $0) }          // converting Strings to NSURL, skipping if NSURL returns nil
    }
    
}
