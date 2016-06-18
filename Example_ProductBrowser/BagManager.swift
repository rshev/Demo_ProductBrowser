//
//  BagManager.swift
//  Example_ProductBrowser
//
//  Created by asdfgh1 on 17/06/2016.
//  Copyright © 2016 rshev. All rights reserved.
//

import Foundation
import RxSwift

class BagManager {
    static let sharedManager = BagManager()
    private init() {}
    
    var bagContents: [Product: Int] = [:]
    
    private let _bagItemsCount = Variable(0)
    var bagItemsCount$: Observable<Int> {
        return _bagItemsCount.asObservable().distinctUntilChanged()
    }
    
    func addProductToBag(product: Product) {
        // subscripting a dictionary returns optional, treat it as zero if the product is not there
        bagContents[product] = (bagContents[product] ?? 0) + 1
        updateItemsCount()
    }
    
    private func updateItemsCount() {
        // this logic depends on how we calc items in a bag - as number of products or as quantities of every product summed up. as it wasn't specified in the exercise spec, I'll calculate it as a sum of all ordered items, to make it a little bit more complicated
        _bagItemsCount.value = bagContents.reduce(0, combine: { (sum: Int, element: (_: Product, count: Int)) -> Int in
            
            return sum + element.count
        })
    }
    
    func getFormattedBagContents() -> String {
        // mapping a dictionary gives a (Key, Value) tuple, produce an array and then join it with a newline
        return "count=\(_bagItemsCount.value)\n" + bagContents.map({ (element: (product: Product, count: Int)) -> String in
            
            return "id=\(element.product.id), quantity=\(element.count)"
        }).joinWithSeparator("\n")
    }
    
}
