//
//  ViewModelTests.swift
//  Example_ProductBrowser
//
//  Created by asdfgh1 on 19/06/2016.
//  Copyright © 2016 rshev. All rights reserved.
//

import XCTest
import RxSwift
@testable import Example_ProductBrowser

class ViewModelTests: XCTestCase {
    
    private let disposeBag = DisposeBag()
    
    func testMenuViewModel() {
        
        // mocking MenuViewModelDelegate class here, and injecting expectations we expect to be fulfilled by MenuViewModel delegate calls. This allows us to check when delegate being called, with which parameters and check if there are extra/unexpected delegate calls being made.
        class MenuViewModelDelegateMock: MenuViewModelDelegate {
            
            var expectationsForRefreshListOfCategories: [XCTestExpectation]
            var expectationsForSelectSectionNumber: [XCTestExpectation]
            var expectationsForPassViewModelFurther: [XCTestExpectation]
            
            init(expectationsForRefreshListOfCategories: [XCTestExpectation], expectationsForSelectSectionNumber: [XCTestExpectation], expectationsForPassViewModelFurther: [XCTestExpectation]) {
                
                self.expectationsForRefreshListOfCategories = expectationsForRefreshListOfCategories
                self.expectationsForSelectSectionNumber = expectationsForSelectSectionNumber
                self.expectationsForPassViewModelFurther = expectationsForPassViewModelFurther
            }
            
            private func menuRefreshListOfCategories() {
                if let expectation = expectationsForRefreshListOfCategories.popLast() {
                    expectation.fulfill()
                } else {
                    XCTFail("unexpected RefreshListOfCategories delegate call")
                }
            }
            
            private func menuSelectSectionNumber(num: Int) {
                if let expectation = expectationsForSelectSectionNumber.popLast() where num == 1 {
                    
                    expectation.fulfill()
                } else {
                    XCTFail("unexpected SelectSectionNumber delegate call")
                }
            }
            
            private func menuPassCategoryProductListViewModelFurther(viewModel: ProductListViewModel) {
                
                if let expectation = expectationsForPassViewModelFurther.popLast() {
                    expectation.fulfill()
                } else {
                    XCTFail("unexpected PassViewModelFurther delegate call")
                }
            }
        }
        
        // loading sections with CatManager, it's a dependency for MenuViewModel
        let sectionsLoadExpectation = expectationWithDescription("Expect CatManager to load 2 sections")
        CatManager.sharedManager.sections$.subscribeNext { (sections) in
            if sections.count == 2 {
                sectionsLoadExpectation.fulfill()
            }
        }.addDisposableTo(disposeBag)
        waitForExpectationsWithTimeout(10, handler: nil)

        let menuViewModel = MenuViewModel()
        
        let expectationRefreshList1 = expectationWithDescription("Expect to refresh list of categories on delegate for the 1st time")
        let expectationSectionNumber1 = expectationWithDescription("Expect to receive select section number with value=1 on delegate")
        let expectationNewProductListViewModel = expectationWithDescription("Expect to receive ProductListViewModel when category will be selected on delegate")
        
        let menuViewModelDelegateMock = MenuViewModelDelegateMock(expectationsForRefreshListOfCategories: [expectationRefreshList1], expectationsForSelectSectionNumber: [expectationSectionNumber1], expectationsForPassViewModelFurther: [expectationNewProductListViewModel])
        menuViewModel.delegate = menuViewModelDelegateMock
        
        XCTAssertEqual(menuViewModel.sectionNames.count, 2, "Wrong sections count")
        XCTAssertTrue(menuViewModel.sectionNames.contains("MEN"), "Section names don't contain MEN")
        XCTAssertTrue(menuViewModel.sectionNames.contains("WOMEN"), "Section names don't contain WOMEN")
        
        let catNames0 = menuViewModel.sectionCategoryNames
        menuViewModel.selectSectionNumber(1)
        let catNames1 = menuViewModel.sectionCategoryNames
        XCTAssertFalse(catNames0 == catNames1, "SelectSectionNumber didn't changed actual category list")
        
        menuViewModel.selectCategoryAtRow(1)
        
        waitForExpectationsWithTimeout(10, handler: nil)
    }
    
}
