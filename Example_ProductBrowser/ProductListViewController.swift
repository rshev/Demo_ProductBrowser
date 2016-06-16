//
//  ProductListViewController.swift
//  Example_ProductBrowser
//
//  Created by asdfgh1 on 12/06/2016.
//  Copyright © 2016 rshev. All rights reserved.
//

import UIKit
import RxSwift

class ProductListViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    weak var viewModel: ProductListViewModel?
    
    private let disposeBag = DisposeBag()
    
    var collectionViewVisible = false {
        willSet {
            UIView.animateWithDuration(0.5) { [weak self] in
                self?.collectionView.alpha = newValue ? 1.0 : 0.0
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.alpha = 0

        self.performSegueWithIdentifier(R.segue.productListViewController.hamburgerMenu.identifier, sender: self)
    }

    @IBAction func unwindWithSelectedCategoryId(segue: UIStoryboardSegue) {
        collectionViewVisible = false
        viewModel?.requestCategoryDetails().observeOn(MainScheduler.instance)
            .subscribeNext({ [weak self] in
                
            self?.collectionViewVisible = true
            self?.collectionView.reloadData()
        }).addDisposableTo(disposeBag)
    }
    
    @IBAction func doubleTapRecognize(sender: UITapGestureRecognizer) {
        guard sender.state == .Ended else { return }
        
        let point = sender.locationInView(collectionView)
        if let indexPath = collectionView.indexPathForItemAtPoint(point) {
            viewModel?.triggerFavoriteForItem(indexPath.item)
        }
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
        // set here because MenuVC sets ViewModel only after selecting a category
        viewModel?.delegate = self

        viewModel?.productWasSelected(index: indexPath.item)
    }
    
}
