//
//  Backend.swift
//  Example_ProductBrowser
//
//  Created by asdfgh1 on 11/06/2016.
//  Copyright © 2016 rshev. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import Unbox

struct Backend {
    
    private static let provider = RxMoyaProvider<BackendTarget>()
    
    // common network request handler, with retry and returning NSData
    private static func request(target: BackendTarget) -> Observable<NSData> {
        return provider.request(target)
            .retryIfMoyaUnreachable()
            .filterSuccessfulStatusCodes()
            .flatMap({ (response) -> Observable<NSData> in
                
                return Observable.just(response.data)
            })
    }
    
    static func requestSection(type type: SectionType) -> Observable<Section> {
        let target: BackendTarget
        switch type {
        case .Men:
            target = .GetCategoriesListMen
        case .Women:
            target = .GetCategoriesListWomen
        }
        return request(target).flatMap({ (data) -> Observable<Section> in
            let section: Section = try Unbox(data)          // if unbox throws, the whole observable throws
            return Observable.just(section)
        })
    }
    
    static func requestProductsInCategory(categoryId id: String) -> Observable<CategoryDetails> {
        return request(.GetProductsInCategory(catId: id)).flatMap({ (data) -> Observable<CategoryDetails> in
            let categoryDetails: CategoryDetails = try Unbox(data)
            return Observable.just(categoryDetails)
        })
    }
    
    static func requestProductDetails(productId id: Int) -> Observable<ProductDetails> {
        return request(.GetProductDetails(productId: id)).flatMap({ (data) -> Observable<ProductDetails> in
            let productDetails: ProductDetails = try Unbox(data)
            return Observable.just(productDetails)
        })
    }
    
}

public enum BackendTarget {
    case GetCategoriesListMen
    case GetCategoriesListWomen
    case GetProductsInCategory(catId: String)
    case GetProductDetails(productId: Int)
}

extension BackendTarget: TargetType {
    
    public var baseURL: NSURL {
        return NSURL(string: "https://dl.dropboxusercontent.com/u/1559445/ASOS/SampleApi")!
    }
    
    public var method: Moya.Method {
        switch self {
        default:
            return .GET
        }
    }
    
    public var path: String {
        switch self {
        case .GetCategoriesListMen:
            return "/cats_men.json"
        case .GetCategoriesListWomen:
            return "/cats_women.json"
        case .GetProductDetails:
            return "/anyproduct_details.json"
        case .GetProductsInCategory:
            return "/anycat_products.json"
        }
    }
    
    public var parameters: [String : AnyObject]? {
        switch self {
        case .GetCategoriesListMen, .GetCategoriesListWomen:
            return nil
        case .GetProductDetails(productId: let productId):
            return ["catid": productId]
        case .GetProductsInCategory(catId: let catId):
            return ["catid": catId]
        }
    }
    
    public var sampleData: NSData {
        return NSData()
    }
    
}
