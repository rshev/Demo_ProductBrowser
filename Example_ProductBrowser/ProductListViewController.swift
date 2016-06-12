//
//  ProductListViewController.swift
//  Example_ProductBrowser
//
//  Created by asdfgh1 on 12/06/2016.
//  Copyright © 2016 rshev. All rights reserved.
//

import UIKit

class ProductListViewController: UIViewController {

    @IBOutlet weak var hamburgerBarButton: UIBarButtonItem!
    
    var selectedCategoryId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.performSegueWithIdentifier(R.segue.productListViewController.hamburgerMenu.identifier, sender: self)
    }

    @IBAction func unwindWithSelectedCategoryId(segue: UIStoryboardSegue) {
        printl(selectedCategoryId)
        
    }
    
    
    
}
