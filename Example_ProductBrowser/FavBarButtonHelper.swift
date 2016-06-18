//
//  FavBarButtonHelper.swift
//  Example_ProductBrowser
//
//  Created by asdfgh1 on 18/06/2016.
//  Copyright © 2016 rshev. All rights reserved.
//

import UIKit
import RxSwift

// the purpose of this Helper is to be re-usable on many ViewControllers, handling bar button tap to provide seamless experience from any ViewController

class FavBarButtonHelper {
    
    private weak var viewControllerToManage: UIViewController?
    private weak var favBarButton: UIBarButtonItem?
    
    init(viewControllerWithNavigationItem: UIViewController, favBarButton: UIBarButtonItem) {
        self.viewControllerToManage = viewControllerWithNavigationItem
        self.favBarButton = favBarButton
        
        self.favBarButton?.rx_tap.subscribeNext({ [weak self] in
            let alertController = UIAlertController(title: "Favorites contents", message: FavManager.sharedManager.getFormattedFavs(), preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
            self?.viewControllerToManage?.presentViewController(alertController, animated: true, completion: nil)
        }).addDisposableTo(disposeBag)
    }
    
    private let disposeBag = DisposeBag()
}
