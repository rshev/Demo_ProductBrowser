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

struct Backend {
    static let provider = RxMoyaProvider<BackendTarget>()
    
    enum ErrorJSON: ErrorType {
        case NotDictionary, NoRequiredKeys
        case BackendMessage(err: String)
        case NetworkUnreachable
    }
    
    /// QIU (d: false) should not be used for user reactions; autoRetries (d: true)
    static func requestJSON(target: BackendTarget, requiredKeys: Set<String>, queueIfUnreachable: Bool = false, autoRetries: Bool = true) -> Observable<JSON> {
        
        if !queueIfUnreachable {
            guard ReachabilityService.sharedService.isReachable else {
                GlobalBanner.showBannerNetworkError()
                return Observable.error(ErrorJSON.NetworkUnreachable)
            }
        }
        var observable = provider.request(target)
        if autoRetries { observable = observable.retryIfMoyaUnreachable() }     // here we handle connectivity errors
        return observable
            .retryIfServerStatusCodeOverload()
            .flatMap({ (response) -> Observable<JSON> in
                
                let json = JSON(data: response.data)
                if !requiredKeys.isEmpty {
                    guard let jsonKeys = json.dictionaryObject?.keys else {
                        // FIXME: Report it via analytics
                        printl("***ERROR*** \(ErrorJSON.NotDictionary)")
                        //                        printl(response.statusCode)
                        //                        printl(NSString(data: response.data, encoding: NSUTF8StringEncoding))
                        GlobalBanner.showBannerNetworkError()
                        throw ErrorJSON.NotDictionary
                    }
                    guard requiredKeys.isSubsetOf(jsonKeys) else {
                        // FIXME: Report it via analytics
                        printl("***ERROR*** \(ErrorJSON.NoRequiredKeys)")
                        GlobalBanner.showBannerNetworkError()
                        throw ErrorJSON.NoRequiredKeys
                    }
                }
                if let err = json["error"].string {
                    printl("*ERROR*BACKENDMSG* \(err)")
                    GlobalBanner.showBanner(.Error, title: "Uh-oh, backend returned:", subtitle: err)
                    throw ErrorJSON.BackendMessage(err: err)
                }
                return Observable.just(json)
            })
    }
    
}

public enum BackendTarget {
    case GetCategoriesListMen
    case GetCategoriesListWomen
    case GetProductInCategory(catId: String)
    case GetProductDetails(productId: String)
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
        case .GetProductInCategory:
            return "/anycat_products.json"
        }
    }
    
    public var parameters: [String : AnyObject]? {
        switch self {
        case .GetCategoriesListMen, .GetCategoriesListWomen:
            break
        case .GetProductDetails(productId: let productId):
            return ["catid": productId]
        case .GetProductInCategory(catId: let catId):
            return ["catid": catId]
        }
    }
    
    // DON'T FORGET TO MODIFY TESTS !!!
    
    public var sampleData: NSData {
        // WARNING: make it real
        return NSData()
        //        @objc class TestClass: NSObject { }
        //
        //        let filename = self.path.substringFromIndex(self.path.startIndex.successor()).stringByReplacingOccurrencesOfString("/", withString: "-")
        //
        //        let bundle = NSBundle(forClass: TestClass.self)
        //        let path = bundle.pathForResource(filename, ofType: "json")
        //        return NSData(contentsOfFile: path!)!
    }
    
}
