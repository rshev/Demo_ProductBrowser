//
//  Category.swift
//  Example_ProductBrowser
//
//  Created by asdfgh1 on 11/06/2016.
//  Copyright © 2016 rshev. All rights reserved.
//

import Foundation
import Unbox

struct Category: Unboxable {
    
    let id: String
    let name: String
    var details: CategoryDetails?
    
    init(unboxer: Unboxer) {
        id = unboxer.unbox("CategoryId")
        name = unboxer.unbox("Name")
    }
    
    mutating func assignDetails(categoryDetails: CategoryDetails) {
        details = categoryDetails
    }
}
