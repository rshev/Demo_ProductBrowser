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
    
    private let disposeBag = DisposeBag()
    
    var selectedSection: Int = 0 {
        didSet {
            guard selectedSection != oldValue else { return }
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        SideMenuManager.menuFadeStatusBar = false
        CatManager.sharedManager.sections.driveNext { [weak self] (sections) in
            self?.buttonLeft.setTitle(sections[0].title, forState: .Normal)
            self?.buttonRight.setTitle(sections[1].title, forState: .Normal)
        }.addDisposableTo(disposeBag)
        
        buttonLeft.rx_tap.subscribeNext { [weak self] in
            self?.selectedSection = 0
        }.addDisposableTo(disposeBag)
        
        buttonRight.rx_tap.subscribeNext { [weak self] in
            self?.selectedSection = 1
        }.addDisposableTo(disposeBag)
        
        CatManager.sharedManager.sections.drive(tableView.rx_itemsWithCellIdentifier("CatCell", cellType: UITableViewCell.self))  { (row, section, cell) in
            
            cell.textLabel?.text = section.categories[row].name
        }.addDisposableTo(disposeBag)
    }


}
