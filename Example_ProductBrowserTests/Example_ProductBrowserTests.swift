//
//  Example_ProductBrowserTestsObjects.swift
//  Example_ProductBrowserTests
//
//  Created by asdfgh1 on 11/06/2016.
//  Copyright © 2016 rshev. All rights reserved.
//

import XCTest
import Unbox
@testable import Example_ProductBrowser

class Example_ProductBrowserTestsObjects: XCTestCase {
    
    let jsonMockupSection: [String: AnyObject] = [
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
    
    let jsonMockupCategory: [String: AnyObject] = [
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
    
    func getMockedSection() throws -> Section {
        return try Unbox(jsonMockupSection)
    }
    
    func getMockedCategoryDetailed() throws -> Example_ProductBrowser.Category {
        let section = try getMockedSection()
        var category = section.categories[0]
        let categoryDetails: CategoryDetails = try Unbox(jsonMockupCategory)
        category.assignDetails(categoryDetails)
        return category
    }
    
    func testSection() {
        do {
            let section = try getMockedSection()
            XCTAssertEqual(section.title, "WOMEN", "Description not mapped to object's title")
            XCTAssertEqual(section.categories.count, 3, "Wrong parsed categories count")
        }
        catch {
            XCTFail("json unboxing failed")
        }
    }
    
    func testCategory() {
        do {
            let section = try getMockedSection()
            XCTAssertEqual(section.categories[1].id, "catalog01_1000_6992", "CategoryId parsed wrongly")
            XCTAssertEqual(section.categories[2].name, "New In: Designer", "Category Name parsed wrongly")
        }
        catch {
            XCTFail("json unboxing failed")
        }
    }
    
    func testCategoryDetailed() {
        do {
            let category = try getMockedCategoryDetailed()
            XCTAssertEqual(category.details?.products.count, 3, "Wrong parsed products in category count")
        }
        catch {
            XCTFail("json unboxing failed")
        }
    }
    
    func testProduct() {
        do {
            let category = try getMockedCategoryDetailed()
            XCTAssertEqual(category.details?.products[0].id, 1743838, "Wrong productId")
            XCTAssertEqual(category.details?.products[1].title, "ASOS Mini Skirt With Pocket Front Panel", "Wrong product title")
            XCTAssertEqual(category.details?.products[2].brand, "ASOS", "Wrong product brand")
            XCTAssertEqual(category.details?.products[0].formattedPrice, "£30.00", "Wrong formatted price")
            XCTAssertEqual(category.details?.products[1].imageUrl, NSURL(string: "http://images.asos.com/inv/media/6/1/6/5/1755616/spectrumblue/image1xl.jpg")!, "Wrong image url")
            XCTAssertEqual(category.details?.products[2].hashValue, 1760169, "Error in Product Hashable")
            XCTAssertFalse(category.details?.products[0] == category.details?.products[1], "Error in Product Comparable")
        }
        catch {
            XCTFail("json unboxing failed")
        }
    }
    /*
    func testProductDetailed() {
        do {
            let section: Section = try Unbox(jsonMockupSection)
            var category = section.categories[0]
            let categoryDetails: CategoryDetails = try Unbox(jsonMockupCategory)
            category.assignDetails(categoryDetails)
            var product = category.details?.products[0]
//            let productDetails: ProductDetails = try Unbox(
            XCTAssertEqual(category.details?.products[0].id, 1743838, "Wrong productId")
            XCTAssertEqual(category.details?.products[1].title, "ASOS Mini Skirt With Pocket Front Panel", "Wrong product title")
            XCTAssertEqual(category.details?.products[2].brand, "ASOS", "Wrong product brand")
            XCTAssertEqual(category.details?.products[0].formattedPrice, "£30.00", "Wrong formatted price")
            XCTAssertEqual(category.details?.products[1].imageUrl, NSURL(string: "http://images.asos.com/inv/media/6/1/6/5/1755616/spectrumblue/image1xl.jpg")!, "Wrong image url")
            XCTAssertEqual(category.details?.products[2].hashValue, 1760169, "Error in Product Hashable")
            XCTAssertFalse(category.details?.products[0] == category.details?.products[1], "Error in Product Comparable")
        }
        catch {
            XCTFail("json unboxing failed")
        }
    }
    */
}
