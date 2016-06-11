//
//  CategoryDetails.swift
//  Example_ProductBrowser
//
//  Created by asdfgh1 on 11/06/2016.
//  Copyright © 2016 rshev. All rights reserved.
//

import Foundation
import Unbox

struct CategoryDetails: Unboxable {
    
    let products: [Product]
    
    init(unboxer: Unboxer) {
        products = unboxer.unbox("Listings")
    }
    
}
