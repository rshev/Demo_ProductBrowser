//
//  ProductDetailsViewModel.swift
//  Example_ProductBrowser
//
//  Created by asdfgh1 on 14/06/2016.
//  Copyright © 2016 rshev. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import AlamofireImage

class ProductDetailsViewModel {
    
    private var product: Product
    
    private let disposeBag = DisposeBag()
    private let imageCache = AutoPurgingImageCache()
    private let imageDownloader = ImageDownloader()
    
    init(product: Product) {
        self.product = product
    }
    
    func requestCategoryDetails() -> Observable<Void> {
        return Backend.requestProductDetails(productId: product.id).observeOn(MainScheduler.instance)
            .flatMap({ [weak self] (productDetails) -> Observable<Void> in
                
            self?.product.assignDetails(productDetails)
            return Observable.just()
        })
    }
    
    func getProductBrand() -> String {
        return product.brand
    }
    
    func getProductDescription() -> String {
        return product.details?.desc ?? ""
    }
    
    func getProductImagesCount() -> Int {
        return product.details?.imageUrls.count ?? 0
    }
    
    // in completion closure I return wasLocal=true if image was found in cache, suggesting that it took very small amount of time to load it and the image can be assigned to cell immediately without re-referencing the cell by its indexPath. If wasLocal=false the image was downloaded from the Internet and the cell should be re-referenced by its indexPath again to assign the image.
    func getProductImage(index index: Int, completion: ((wasLocal: Bool, image: UIImage?)->Void)) {
        guard let imageUrl = product.details?.imageUrls[index] else { return }
        let imageUrlRequest = NSURLRequest(URL: imageUrl)
        
        if let image = imageCache.imageForRequest(imageUrlRequest) {
            completion(wasLocal: true, image: image)
            return
        }
        
        imageDownloader.downloadImage(URLRequest: imageUrlRequest) { [weak self] (response) in
            if let image = response.result.value {
                // minding that we could be not on the main queue after image download here
                NSOperationQueue.mainQueue().addOperationWithBlock({ 
                    completion(wasLocal: false, image: image)
                })
                self?.imageCache.addImage(image, forRequest: imageUrlRequest)
            }
        }
    }
    
    func getProductBagPriceButtonFormatted() -> String {
        return "Add to Bag (\(product.formattedPrice))"
    }
    
    func addProductToBag() {
        BagManager.sharedManager.addProductToBag(product)
    }
    
}
