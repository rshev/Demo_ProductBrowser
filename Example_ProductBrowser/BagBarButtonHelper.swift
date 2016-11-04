//
//  BagBarButtonHelper.swift
//  Example_ProductBrowser
//
//  Created by asdfgh1 on 17/06/2016.
//  Copyright © 2016 rshev. All rights reserved.
//

import UIKit
import RxSwift

// the purpose of this Helper is to be re-usable on many ViewControllers, listening for BagManager count
// changes and then replacing ViewController Bag BarButtonItem with another one with a new rendered bag
// with items count inside. Also handles bar button tap to provide seamless experience from any ViewController

class BagBarButtonHelper {
    
    private weak var viewControllerToManage: UIViewController?
    
    private weak var currentBarItem: UIBarButtonItem?
    
    init(viewControllerWithNavigationItem: UIViewController) {
        self.viewControllerToManage = viewControllerWithNavigationItem
        
        BagManager.sharedManager.bagItemsCount$.observeOn(MainScheduler.instance).subscribeNext { [weak self] (count) in
            
            self?.replaceButton(newBagCount: count)
        }.addDisposableTo(disposeBag)

    }
    
    private let disposeBag = DisposeBag()
    
    private func replaceButton(newBagCount count: Int) {
        let text = "\(count)"
        let newImage = renderNewImage(text: text)
        let newBarItem = UIBarButtonItem(image: newImage, style: .Plain, target: self, action: #selector(self.buttonTap))
        
        var newBarItems = viewControllerToManage?.navigationItem.rightBarButtonItems?.filter({ $0 !== self.currentBarItem })
        newBarItems?.insert(newBarItem, atIndex: 0)
        viewControllerToManage?.navigationItem.setRightBarButtonItems(newBarItems, animated: true)
        
        currentBarItem = newBarItem
    }
    
    // shifting value for bag text relative to button image
    private let labelShiftY: CGFloat = 4
    
    private func renderNewImage(text text: String) -> UIImage? {
        let bagImage = R.image.basket()!            // unwrapping explicitly here because if asset disappears the code won't compile because of R.Swift auto-regenerating nature
        
        let rect = CGRect(origin: CGPointZero, size: bagImage.size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        bagImage.drawInRect(rect)
        let textRect = CGRect(origin: CGPoint(x: 0, y: labelShiftY), size: CGSize(width: rect.size.width, height: rect.size.height - labelShiftY))
        countLabel.text = text
        countLabel.drawTextInRect(textRect)
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return outputImage
    }
    
    private let countLabel: UILabel = {
        let l = UILabel()
        l.contentMode = .Center
        l.textAlignment = .Center
        l.font = UIFont.preferredFontForTextStyle(UIFontTextStyleFootnote)
        return l
    }()

    @objc func buttonTap() {
        let alertController = UIAlertController(title: "Bag contents", message: BagManager.sharedManager.getFormattedBagContents(), preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
        viewControllerToManage?.presentViewController(alertController, animated: true, completion: nil)
    }
    
}
