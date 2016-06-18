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
    
    func testSection() {
        do {
            let section = try ObjectMocks.getMockedSection()
            XCTAssertEqual(section.title, "WOMEN", "Description not mapped to object's title")
            XCTAssertEqual(section.categories.count, 3, "Wrong parsed categories count")
        }
        catch {
            XCTFail("json unboxing failed")
        }
    }
    
    func testCategory() {
        do {
            let section = try ObjectMocks.getMockedSection()
            XCTAssertEqual(section.categories[1].id, "catalog01_1000_6992", "CategoryId parsed wrongly")
            XCTAssertEqual(section.categories[2].name, "New In: Designer", "Category Name parsed wrongly")
        }
        catch {
            XCTFail("json unboxing failed")
        }
    }
    
    func testCategoryDetailed() {
        do {
            let category = try ObjectMocks.getMockedCategoryDetailed()
            XCTAssertEqual(category.details?.products.count, 3, "Wrong parsed products in category count")
        }
        catch {
            XCTFail("json unboxing failed")
        }
    }
    
    func testProduct() {
        do {
            let category = try ObjectMocks.getMockedCategoryDetailed()
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
