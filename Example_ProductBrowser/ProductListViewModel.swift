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
import AlamofireImage

protocol ProductListViewModelDelegate: class {
    func productPassProductDetailsViewModelFurther(viewModel: ProductDetailsViewModel)
}

class ProductListViewModel {
    
    private var category: Category
    
    private let disposeBag = DisposeBag()
    private let imageCache = AutoPurgingImageCache()
    private let imageDownloader = ImageDownloader()
    
    weak var delegate: ProductListViewModelDelegate?
    
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
        guard let imageUrl = category.details?.products[index].imageUrl else { return }
        let imageUrlRequest = NSURLRequest(URL: imageUrl)
        
        if let image = imageCache.imageForRequest(imageUrlRequest) {
            completion(wasLocal: true, image: image)
            return
        }
        
        imageDownloader.downloadImage(URLRequest: imageUrlRequest) { [weak self] (response) in
            if let image = response.result.value {
                completion(wasLocal: false, image: image)
                self?.imageCache.addImage(image, forRequest: imageUrlRequest)
            }
        }
    }
    
    func getProductPrice(index index: Int) -> String {
        return category.details?.products[index].formattedPrice ?? ""
    }
    
    func triggerFavoriteForItem(index: Int) {
        printl(index)
    }
    
    func productWasSelected(index index: Int) {
        guard let product = category.details?.products[index] else { return }
        let productDetailsViewModel = ProductDetailsViewModel(product: product)
        delegate?.productPassProductDetailsViewModelFurther(productDetailsViewModel)
    }
    
}
