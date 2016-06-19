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
            XCTFail("json unboxing failed: \(error)")
        }
    }
    
    func testCategory() {
        do {
            let section = try ObjectMocks.getMockedSection()
            XCTAssertEqual(section.categories[1].id, "catalog01_1000_6992", "CategoryId parsed wrongly")
            XCTAssertEqual(section.categories[2].name, "New In: Designer", "Category Name parsed wrongly")
        }
        catch {
            XCTFail("json unboxing failed: \(error)")
        }
    }
    
    func testCategoryDetailed() {
        do {
            let category = try ObjectMocks.getMockedCategoryDetailed()
            XCTAssertEqual(category.details?.products.count, 3, "Wrong parsed products in category count")
        }
        catch {
            XCTFail("json unboxing failed: \(error)")
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
            XCTFail("json unboxing failed: \(error)")
        }
    }
    
    func testProductDetailed() {
        do {
            let product = try ObjectMocks.getMockedProductDetailed()
            XCTAssertEqual(product.details?.desc, "Fringed crop top, featuring a reinforced boat neckline, raglan style slashed sleeves with tasselled fringe trim, and a cropped length, in a sheer finish.", "Wrong product description")
            XCTAssertEqual(product.details?.imageUrls.count, 4, "Wrong images count")
            XCTAssertEqual(product.details?.imageUrls[1], NSURL(string: "http://images.asos.com/inv/media/9/8/4/3/1703489/image2xxl.jpg")!, "Wrong image URL")
        }
        catch {
            XCTFail("json unboxing failed: \(error)")
        }
    }
    
}
