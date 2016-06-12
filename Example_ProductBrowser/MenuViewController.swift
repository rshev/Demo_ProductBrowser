//
//  MenuViewController.swift
//  Example_ProductBrowser
//
//  Created by asdfgh1 on 11/06/2016.
//  Copyright © 2016 rshev. All rights reserved.
//

import UIKit
import SideMenu

class MenuViewController: UIViewController {

    @IBOutlet weak var buttonLeft: UIButton!
    @IBOutlet weak var buttonRight: UIButton!
    @IBOutlet weak var tableView: UITableView!

    private let viewModel = MenuViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SideMenuManager.menuFadeStatusBar = false

        viewModel.delegate = self
        
        buttonLeft.setTitle(viewModel.sectionNames[0], forState: .Normal)
        buttonRight.setTitle(viewModel.sectionNames[1], forState: .Normal)
        
    }

    @IBAction func buttonLeftTap(sender: AnyObject) {
        viewModel.selectSectionNumber(0)
    }
    
    @IBAction func buttonRightTap(sender: AnyObject) {
        viewModel.selectSectionNumber(1)
    }
    
}

extension MenuViewController: MenuViewModelDelegate {
    
    func menuRefreshListOfCategories() {
        tableView.reloadData()
    }
    
    func menuSelectSectionNumber(num: Int) {
        //
    }
    
    func menuPassCategoryIdFurther(id: String) {
        //
    }
    
}

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sectionCategoryNames.count
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(R.reuseIdentifier.catCell.identifier, forIndexPath: indexPath)
        cell.textLabel?.text = viewModel.sectionCategoryNames[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        viewModel.selectCategoryAtRow(indexPath.row)
    }
    
}
