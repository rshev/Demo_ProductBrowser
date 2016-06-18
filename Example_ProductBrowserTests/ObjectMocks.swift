//
//  ObjectMocks.swift
//  Example_ProductBrowser
//
//  Created by asdfgh1 on 18/06/2016.
//  Copyright © 2016 rshev. All rights reserved.
//

import Foundation
import Unbox
@testable import Example_ProductBrowser

class ObjectMocks {
    
    static let jsonMockupSection: [String: AnyObject] = [
        "Description": "WOMEN",
        "Listing": [
            [
                "CategoryId": "catalog01_1000_2623",
                "Name": "New In: Clothing",
                "ProductCount": 211
            ],
            [
                "CategoryId": "catalog01_1000_6992",
                "Name": "New In: Shoes",
                "ProductCount": 194
            ],
            [
                "CategoryId": "catalog01_1000_6930",
                "Name": "New In: Designer",
                "ProductCount": 0
            ]]]
    
    class func getMockedSection() throws -> Section {
        return try Unbox(jsonMockupSection)
    }
    
    static let jsonMockupCategory: [String: AnyObject] = [
        "Description": "New In: Clothing",
        "ItemCount": 33,
        "Listings": [
            [
                "BasePrice": 30.0,
                "Brand": "ASOS",
                "CurrentPrice": "£30.00",
                "HasMoreColours": true,
                "IsInSet": false,
                "PreviousPrice": "",
                "ProductId": 1743838,
                "ProductImageUrl": [
                    "http://images.asos.com/inv/media/8/3/8/3/1743838/creamblack/image1xl.jpg"
                ],
                "RRP": "",
                "Title": "ASOS Blouse With Tipped Drop Collar"
            ],
            [
                "BasePrice": 30.0,
                "Brand": "ASOS",
                "CurrentPrice": "£30.00",
                "HasMoreColours": false,
                "IsInSet": false,
                "PreviousPrice": "",
                "ProductId": 1755616,
                "ProductImageUrl": [
                    "http://images.asos.com/inv/media/6/1/6/5/1755616/spectrumblue/image1xl.jpg"
                ],
                "RRP": "",
                "Title": "ASOS Mini Skirt With Pocket Front Panel"
            ],
            [
                "BasePrice": 30.0,
                "Brand": "ASOS",
                "CurrentPrice": "£30.00",
                "HasMoreColours": false,
                "IsInSet": false,
                "PreviousPrice": "",
                "ProductId": 1760169,
                "ProductImageUrl": [
                    "http://images.asos.com/inv/media/9/6/1/0/1760169/black/image1xl.jpg"
                ],
                "RRP": "",
                "Title": "ASOS Midi Skirt in Quilted Jersey"
            ]]]
    
    class func getMockedCategoryDetailed() throws -> Example_ProductBrowser.Category {
        let section = try getMockedSection()
        var category = section.categories[0]
        let categoryDetails: CategoryDetails = try Unbox(jsonMockupCategory)
        category.assignDetails(categoryDetails)
        return category
    }
    
    static let jsonMockupProduct: [String: AnyObject] = [
        "BasePrice": 35.0,
        "Brand": "ASOS",
        "CurrentPrice": "£35.00",
        "InStock": true,
        "IsInSet": false,
        "PreviousPrice": "",
        "PriceType": "Full",
        "ProductId": 1703489,
        "ProductImageUrls": [
            "http://images.asos.com/inv/media/9/8/4/3/1703489/red/image1xxl.jpg",
            "http://images.asos.com/inv/media/9/8/4/3/1703489/image2xxl.jpg",
            "http://images.asos.com/inv/media/9/8/4/3/1703489/image3xxl.jpg",
            "http://images.asos.com/inv/media/9/8/4/3/1703489/image4xxl.jpg"
        ],
        "RRP": "",
        "Sku": "101050",
        "Title": "ASOS Fringe Sleeve Mesh Crop",
        "AdditionalInfo": "100% Polyester\n\n\n\n\n\nSIZE & FIT \n\nModel wears: UK 8/ EU 36/ US 4\n\n\n\nSize UK 8/ EU 36/ US 4 side neck to hem measures: 46cm/18in",
        "Description": "Fringed crop top, featuring a reinforced boat neckline, raglan style slashed sleeves with tasselled fringe trim, and a cropped length, in a sheer finish.",
        ]
    
}
