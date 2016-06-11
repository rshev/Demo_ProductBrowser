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
        
        Driver.combineLatest(CatManager.sharedManager.sectionMen, CatManager.sharedManager.sectionWomen) {
            return ($0, $1)
        }.driveNext { [weak self] (sectionMen, sectionWomen) in
            guard sectionMen != nil && sectionWomen != nil else { return }
            self?.performSegueWithIdentifier(R.segue.startViewController.startToMain.identifier, sender: self)
        }.addDisposableTo(disposeBag)
    }

}
