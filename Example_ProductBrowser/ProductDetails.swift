//
//  ProductDetails.swift
//  Example_ProductBrowser
//
//  Created by asdfgh1 on 11/06/2016.
//  Copyright © 2016 rshev. All rights reserved.
//

import Foundation
import Unbox

struct ProductDetails: Unboxable {
    
    let imageUrls: [NSURL]
    let desc: String

    init(unboxer: Unboxer) {
        imageUrls = unboxer.unbox("ProductImageUrls").flatMap { NSURL(string: $0) }     // converting strings to NSURLs
        desc = unboxer.unbox("Description")
    }

}
