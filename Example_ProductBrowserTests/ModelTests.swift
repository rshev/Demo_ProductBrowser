//
//  ModelTests.swift
//  Example_ProductBrowser
//
//  Created by asdfgh1 on 19/06/2016.
//  Copyright © 2016 rshev. All rights reserved.
//

import XCTest
import RxSwift
@testable import Example_ProductBrowser

class ModelTests: XCTestCase {
    
    private let disposeBag = DisposeBag()
    
    func testCatManager() {
        let expectationForSectionsCallback = expectationWithDescription("expect getting sections callback")
        let expectationForSectionsGet = expectationWithDescription("expect getting sections at all")
        let expectationForSectionsCount = expectationWithDescription("expect getting 2 sections")
        CatManager.sharedManager.sections$.subscribeNext { (sections) in
            switch sections.count {
            case 0:
                expectationForSectionsCallback.fulfill()
            case 1:
                expectationForSectionsGet.fulfill()
            case 2:
                expectationForSectionsCount.fulfill()
            default:
                XCTFail("got wrong number of sections")
            }
            XCTAssertEqual(sections.count, CatManager.sharedManager.sections.count, "Sections observable is inconsistent with sections variable")
        }.addDisposableTo(disposeBag)
        waitForExpectationsWithTimeout(10) { (error) in
            if let error = error {
                XCTFail("expectations failed with error: \(error)")
            }
        }
    }
    
    func testBagManager() {
        func checkCountWithBagContents() {
            XCTAssertEqual(BagManager.sharedManager.bagContents.reduce(0, combine: { $0! + $1.1} ), BagManager.sharedManager.bagItemsCount, "Bag contents and bag counter are out of sync")
        }
        
        do {
            XCTAssertEqual(BagManager.sharedManager.bagContents.count, 0, "Initial bag contents not empty")
            XCTAssertEqual(BagManager.sharedManager.bagItemsCount, 0, "Initial bag counter not zero")
            XCTAssertEqual(BagManager.sharedManager.getFormattedBagContents(), "count=0", "Initial bag formatted contents invalid")
            let product = try ObjectMocks.getMockedProductDetailed()
            BagManager.sharedManager.addProductToBag(product)
            checkCountWithBagContents()
            XCTAssertEqual(BagManager.sharedManager.getFormattedBagContents(), "count=1\nid=\(product.id), quantity=1", "Invalid formatted bag contents")
            BagManager.sharedManager.addProductToBag(product)
            checkCountWithBagContents()
            XCTAssertEqual(BagManager.sharedManager.getFormattedBagContents(), "count=2\nid=\(product.id), quantity=2", "Invalid formatted bag contents")
            XCTAssertEqual(BagManager.sharedManager.bagContents.count, 1, "The same product should only increment the items count")
            XCTAssertEqual(BagManager.sharedManager.bagItemsCount, 2, "Items count should contain all items quantities combined")
            
        }
        catch {
            XCTFail("\(error)")
        }
    }
    
    func testFavManager() {
        do {
            let product = try ObjectMocks.getMockedProductDetailed()
            XCTAssertEqual(FavManager.sharedManager.favProducts.count, 0, "Initial fav contents not empty")
            XCTAssertFalse(FavManager.sharedManager.isFav(product: product), "isFav for not favorited product should return false")
            XCTAssertEqual(FavManager.sharedManager.getFormattedFavs(), "count=0", "Initial formatted fav contents invalid")
            FavManager.sharedManager.triggerFav(product: product)
            XCTAssertEqual(FavManager.sharedManager.favProducts.count, 1, "Fav items count is invalid")
            XCTAssertTrue(FavManager.sharedManager.isFav(product: product), "isFav for favorited product should return true")
            XCTAssertEqual(FavManager.sharedManager.getFormattedFavs(), "count=1\nid=\(product.id) title=\(product.title)", "Formatted fav contents invalid")
            FavManager.sharedManager.triggerFav(product: product)
            XCTAssertEqual(FavManager.sharedManager.favProducts.count, 0, "Fav items count is invalid")
            XCTAssertFalse(FavManager.sharedManager.isFav(product: product), "isFav for not favorited product should return false")
            XCTAssertEqual(FavManager.sharedManager.getFormattedFavs(), "count=0", "Formatted fav contents invalid")
        }
        catch {
            XCTFail("\(error)")
        }
    }
    
}
