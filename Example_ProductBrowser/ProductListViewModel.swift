//
//  ProductListViewModel.swift
//  Example_ProductBrowser
//
//  Created by asdfgh1 on 12/06/2016.
//  Copyright © 2016 rshev. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ProductListViewModel {
    
    private var category: Category
    
    private let disposeBag = DisposeBag()
    
    init(category: Category) {
        self.category = category
    }
    
    func requestCategoryDetails() -> Observable<Void> {
        return Backend.requestProductsInCategory(categoryId: category.id).observeOn(MainScheduler.instance)
            .flatMap({ [weak self] (categoryDetails) -> Observable<Void> in
            
            self?.category.assignDetails(categoryDetails)
            return Observable.just()
        })
    }
    
    func getProductsCount() -> Int {
        return category.details?.products.count ?? 0
    }
    
    func getCategoryName() -> String {
        return category.name
    }
    
    func getProductImage(index index: Int, completion: ((wasLocal: Bool, image: UIImage?)->Void)) {
        
    }
    
    func getProductPrice(index index: Int) -> String {
        return category.details?.products[index].formattedPrice ?? ""
    }
    
}
