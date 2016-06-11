//
//  Section.swift
//  Example_ProductBrowser
//
//  Created by asdfgh1 on 11/06/2016.
//  Copyright © 2016 rshev. All rights reserved.
//

import Foundation
import Unbox

struct Section: Unboxable {
    
    let title: String
    let categories: [Category]
    
    init(unboxer: Unboxer) {
        title = unboxer.unbox("Description")
        categories = unboxer.unbox("Listing")
    }
    
}

enum SectionType {
    case Men
    case Women
}
