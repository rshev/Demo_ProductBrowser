//
//  ProductDetailsViewController.swift
//  Example_ProductBrowser
//
//  Created by asdfgh1 on 15/06/2016.
//  Copyright © 2016 rshev. All rights reserved.
//

import UIKit
import RxSwift

class ProductDetailsViewController: UIViewController {

    weak var viewModel: ProductDetailsViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel?.requestCategoryDetails()
    }

}
