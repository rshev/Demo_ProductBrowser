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

    @IBOutlet weak var imagesScrollView: UIScrollView!
    @IBOutlet weak var imagesContentView: UIView!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var descTextView: UITextView!
    @IBOutlet weak var bagButton: UIButton!
    @IBOutlet weak var spinnerView: UIActivityIndicatorView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    weak var viewModel: ProductDetailsViewModel?
    
    private let disposeBag = DisposeBag()
    
    var imageViews: [UIImageView] = []
    
    // should be retained here for button actions to work properly
    var bagBarButtonHelper: BagBarButtonHelper?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setContentVisible(false, animated: false)

        // wait for viewModel's signal when its ready to render content
        viewModel?.requestCategoryDetails().observeOn(MainScheduler.instance)
            .subscribeNext({ [weak self] in
                
                self?.renderDetails()
            }).addDisposableTo(disposeBag)
        
        // set pageControl currentPage depending on scrollView's offset
        imagesScrollView.rx_contentOffset.subscribeNext { [weak self] (point) in
            guard let strongSelf = self else { return }
            strongSelf.pageControl.currentPage = Int(round(point.x / strongSelf.view.bounds.width))
        }.addDisposableTo(disposeBag)
        
        // change scrollView offset if pageControl was tapped 
        pageControl.rx_controlEvent(.ValueChanged).subscribeNext { [weak self] in
            guard let strongSelf = self else { return }
            let newOffset = CGPoint(x: CGFloat(strongSelf.pageControl.currentPage) * strongSelf.view.bounds.width, y: 0)
            strongSelf.imagesScrollView.setContentOffset(newOffset, animated: true)
        }.addDisposableTo(disposeBag)
        
        bagBarButtonHelper = BagBarButtonHelper(viewControllerWithNavigationItem: self)
    }

    var lastBounds = CGRectZero
    
    // logic to make paginated scrollView stay on the same page when rotating the device
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard lastBounds != self.view.bounds else { return }
        
        let lastBoundsWidth = lastBounds.width > 0 ? lastBounds.width : 1               // do not divide by zero
        let lastPage = ceil(imagesScrollView.contentOffset.x / lastBoundsWidth)
        let newPageOffset = CGPoint(x: lastPage * self.view.bounds.width, y: 0)
        imagesScrollView.setContentOffset(newPageOffset, animated: false)
        
        lastBounds = self.view.bounds
    }
    
    func renderDetails() {
        guard let viewModel = viewModel else { return }
        
        setContentVisible(true, animated: true)
        brandLabel.text = viewModel.getProductBrand()
        descTextView.text = viewModel.getProductDescription()
        refreshButtonText()
        
        let imageCount = viewModel.getProductImagesCount()
        pageControl.numberOfPages = imageCount
        for index in 0..<imageCount {
            
            let imageView = UIImageView()
            imageViews.append(imageView)
            imageView.contentMode = .ScaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imagesContentView.addSubview(imageView)
            // setting width and height the same as visible scrollView dimensions
            imageView.widthAnchor.constraintEqualToAnchor(imagesScrollView.widthAnchor, multiplier: 1).active = true
            imageView.heightAnchor.constraintEqualToAnchor(imagesContentView.heightAnchor, multiplier: 1).active = true
            // setting centerY is enough because imagesContentView height is already pinned to scrollView height in
            // storyboard. alternatively we can pin top and bottom to contentView.
            imageView.centerYAnchor.constraintEqualToAnchor(imagesContentView.centerYAnchor).active = true
            
            // if it's the first imageView - pin it to the leading edge of contentView, if it's not - pin it
            // to the previous imageView
            if index == 0 {
                imageView.leadingAnchor.constraintEqualToAnchor(imagesContentView.leadingAnchor).active = true
            } else {
                imageView.leadingAnchor.constraintEqualToAnchor(imageViews[index-1].trailingAnchor).active = true
            }
            
            // if it's the last imageView - pin its trailing edge to the trailing edge of contentView.
            // important because without that contentView couldn't calc its width, and scrollView wouldn't
            // know how much it should allow to scroll. note - there is a low-priority width constraint
            // for contentView to not make it all broken up to the moment I add images (or if there is no images)
            if index == imageCount-1 {
                imageView.trailingAnchor.constraintEqualToAnchor(imagesContentView.trailingAnchor).active = true
            }
            
            // load it asynchronously, weakly capturing this imageView to set the image to it later
            viewModel.getProductImage(index: index, completion: { [weak imageView] (_, image) in
                imageView?.image = image
            })
        }
        
    }
    
    func setContentVisible(newValue: Bool, animated: Bool) {
        let newAlpha: CGFloat = newValue ? 1 : 0
        let action = { [weak self] in
            self?.imagesScrollView.alpha = newAlpha
            self?.brandLabel.alpha = newAlpha
            self?.descTextView.alpha = newAlpha
            self?.bagButton.alpha = newAlpha
        }
        _ = animated ? UIView.animateWithDuration(0.5, animations: action) : action()
        _ = newValue ? spinnerView.stopAnimating() : spinnerView.startAnimating()
    }
    
    func refreshButtonText() {
        bagButton.setTitle(viewModel?.getProductBagPriceButtonFormatted(), forState: .Normal)
    }
    
    @IBAction func bagTap() {
        viewModel?.addProductToBag()
    }
    
}
