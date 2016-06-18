//
//  ProductListViewController.swift
//  Example_ProductBrowser
//
//  Created by asdfgh1 on 12/06/2016.
//  Copyright © 2016 rshev. All rights reserved.
//

import UIKit
import RxSwift
import SideMenu

class ProductListViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var favBarButtonItem: UIBarButtonItem!
    
    weak var viewModel: ProductListViewModel?
    
    private let disposeBag = DisposeBag()
    
    var collectionViewVisible = false {
        willSet {
            UIView.animateWithDuration(0.5) { [weak self] in
                self?.collectionView.alpha = newValue ? 1.0 : 0.0
            }
        }
    }
    
    // should be retained here for button actions to work properly
    var bagBarButtonHelper: BagBarButtonHelper?
    var favBarButtonHelper: FavBarButtonHelper?

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.alpha = 0

        hamburgerTap()
        
        bagBarButtonHelper = BagBarButtonHelper(viewControllerWithNavigationItem: self)
        favBarButtonHelper = FavBarButtonHelper(viewControllerWithNavigationItem: self, favBarButton: favBarButtonItem)
    }

    let hamburgerNavigationController: UISideMenuNavigationController = {
        let vc = R.storyboard.hamburgerMenu.initialViewController()!         // force unwrap here only because R.Swift generates a list of resources at build time. It won't compile if there will be no storyboard or viewController there.
        vc.leftSide = true
        SideMenuManager.menuLeftNavigationController = vc
        return vc
    }()
    
    @IBAction func hamburgerTap() {
        hamburgerNavigationController.leftSide = true
        self.presentViewController(hamburgerNavigationController, animated: true, completion: nil)
    }
    
    @IBAction func unwindWithSelectedCategoryId(segue: UIStoryboardSegue) {
        collectionViewVisible = false
        
        // we should have a new viewModel at this point
        viewModel?.delegate = self

        viewModel?.requestCategoryDetails().observeOn(MainScheduler.instance)
            .subscribeNext({ [weak self] in
                
            self?.collectionView.setContentOffset(CGPointZero, animated: false)
            self?.collectionViewVisible = true
            self?.collectionView.reloadData()
        }).addDisposableTo(disposeBag)
    }
    
    @IBAction func doubleTapRecognize(sender: UITapGestureRecognizer) {
        guard sender.state == .Ended else { return }
        
        let point = sender.locationInView(collectionView)
        guard let indexPath = collectionView.indexPathForItemAtPoint(point) else { return }

        viewModel?.triggerFavoriteForItem(indexPath.item)
        collectionView.reloadItemsAtIndexPaths([indexPath])
    }
    
    private var productDetailsViewModelToPassFurther: ProductDetailsViewModel?
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let productDetailsViewController = segue.destinationViewController as? ProductDetailsViewController {
            productDetailsViewController.viewModel = productDetailsViewModelToPassFurther
        }
    }
    
    @IBAction func unwindFromProductDetailsToProductList(segue: UIStoryboardSegue) {}
    
}

extension ProductListViewController: ProductListViewModelDelegate {
    
    func productPassProductDetailsViewModelFurther(viewModel: ProductDetailsViewModel) {
        productDetailsViewModelToPassFurther = viewModel
        self.performSegueWithIdentifier(R.segue.productListViewController.productDetails.identifier, sender: self)
    }
    
}

extension ProductListViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        let view = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: R.reuseIdentifier.header.identifier, forIndexPath: indexPath) as! HeaderCollectionReusableView
        view.textLabel.text = viewModel?.getCategoryName()
        return view
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.getProductsCount() ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(R.reuseIdentifier.productCell.identifier, forIndexPath: indexPath) as! ProductCollectionViewCell
        cell.priceLabel.text = viewModel?.getProductPrice(index: indexPath.item)
        cell.setOutline(viewModel?.isFavProduct(index: indexPath.item) == true)               // comparing to true here to avoid optional unwrapping
        viewModel?.getProductImage(index: indexPath.item, completion: { [weak cell] (wasLocal, image) in
            if wasLocal {
                cell?.setImage(image)
            } else {
                let cell = collectionView.cellForItemAtIndexPath(indexPath) as? ProductCollectionViewCell
                cell?.setImage(image)
            }
        })
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        viewModel?.productWasSelected(index: indexPath.item)
    }
    
}
