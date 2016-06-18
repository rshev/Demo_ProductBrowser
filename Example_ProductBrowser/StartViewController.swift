//
//  ViewController.swift
//  Example_ProductBrowser
//
//  Created by asdfgh1 on 11/06/2016.
//  Copyright © 2016 rshev. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class StartViewController: UIViewController {

    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // waiting for both sections to load and then proceed from the splash screen 
        CatManager.sharedManager.sections$.observeOn(MainScheduler.instance)
            .subscribeNext { [weak self] (sections) in
                
            guard sections.count > 1 else { return }
            self?.performSegueWithIdentifier(R.segue.startViewController.startToMain.identifier, sender: self)
        }.addDisposableTo(disposeBag)
    }
    
}
