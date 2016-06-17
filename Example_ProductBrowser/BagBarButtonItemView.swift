//
//  BagBarButtonItem.swift
//  Example_ProductBrowser
//
//  Created by asdfgh1 on 17/06/2016.
//  Copyright © 2016 rshev. All rights reserved.
//

import UIKit
import RxSwift

class BagBarButtonItemView: UIView {

    let bagImageView = UIImageView(image: R.image.basket())
    let countLabel = UILabel()
    
    private let disposeBag = DisposeBag()
    
    private lazy var oneTimeSetup: Void = {
        self.setup()
    }()
    
    private func setup() {
        bagImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(bagImageView)
        bagImageView.topAnchor.constraintEqualToAnchor(self.topAnchor).active = true
        bagImageView.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor).active = true
        bagImageView.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor).active = true
        bagImageView.trailingAnchor.constraintEqualToAnchor(self.trailingAnchor).active = true
        
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        bagImageView.addSubview(countLabel)
        countLabel.centerXAnchor.constraintEqualToAnchor(bagImageView.centerXAnchor, constant: 0).active = true
        countLabel.centerYAnchor.constraintEqualToAnchor(bagImageView.centerYAnchor, constant: 0).active = true
        
        BagManager.sharedManager.bagItemsCount$.observeOn(MainScheduler.instance).subscribeNext { [weak self] (count) in
            
            let text = count > 0 ? "\(count)" : ""
            self?.countLabel.text = text
        }.addDisposableTo(disposeBag)
    }
    
    override func layoutSubviews() {
        _ = oneTimeSetup
        super.layoutSubviews()
    }
    
}
