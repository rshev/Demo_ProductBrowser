//
//  FavManager.swift
//  Example_ProductBrowser
//
//  Created by asdfgh1 on 18/06/2016.
//  Copyright © 2016 rshev. All rights reserved.
//

import Foundation
import RxSwift

class FavManager {
    static let sharedManager = FavManager()
    private init() {}
    
    var favProducts: Set<Product> = []
    
    func triggerFav(product product: Product) {
        if favProducts.contains(product) {
            favProducts.remove(product)
        } else {
            favProducts.insert(product)
        }
    }
    
    func isFav(product product: Product) -> Bool {
        return favProducts.contains(product)
    }
    
    func getFormattedFavs() -> String {
        return "count=\(favProducts.count)\n" + favProducts.map({ "id=\($0.id)" }).joinWithSeparator("\n")
    }
    
}
