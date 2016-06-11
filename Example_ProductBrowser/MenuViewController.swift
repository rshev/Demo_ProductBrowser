//
//  MenuViewController.swift
//  Example_ProductBrowser
//
//  Created by asdfgh1 on 11/06/2016.
//  Copyright © 2016 rshev. All rights reserved.
//

import UIKit
import SideMenu
import RxSwift
import RxCocoa

class MenuViewController: UIViewController {

    @IBOutlet weak var buttonLeft: UIButton!
    @IBOutlet weak var buttonRight: UIButton!
    @IBOutlet weak var tableView: UITableView!

    private let viewModel = MenuViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SideMenuManager.menuFadeStatusBar = false

        viewModel.sectionNames$.driveNext { [weak self] (sectionNames) in
            self?.buttonLeft.setTitle(sectionNames[0], forState: .Normal)
            self?.buttonRight.setTitle(sectionNames[1], forState: .Normal)
        }.addDisposableTo(disposeBag)
        
        buttonLeft.rx_tap.subscribeNext { [weak self] in
            self?.viewModel.selectSectionNumber(0)
            self?.tableView.reloadData()
        }.addDisposableTo(disposeBag)
        
        buttonRight.rx_tap.subscribeNext { [weak self] in
            self?.viewModel.selectSectionNumber(1)
            self?.tableView.reloadData()
        }.addDisposableTo(disposeBag)

        viewModel.sectionCategoryNames$.drive(tableView.rx_itemsWithCellIdentifier("CatCell", cellType: UITableViewCell.self))(configureCell: { (row, title, cell) in
            
            cell.textLabel?.text = title
        }).addDisposableTo(disposeBag)
        
    }


}
