//
//  PagedScrollView.swift
//  Example_ProductBrowser
//
//  Created by asdfgh1 on 17/06/2016.
//  Copyright © 2016 rshev. All rights reserved.
//

import UIKit

class PagedScrollView: UIScrollView {

    var lastFrameSize = CGSizeZero
    
    // logic to make paged scrollView stay on the same page when rotating the device
    override func layoutSubviews() {
        defer {                                 // invoking super.layoutSubviews if we return at any point
            super.layoutSubviews()
        }
        
        // waiting for significant change (width in particular)
        guard lastFrameSize != self.frame.size else { return }
        if lastFrameSize.width == 0 {
            lastFrameSize = self.frame.size
            return
        }
        
        let lastPage = ceil(self.contentOffset.x / lastFrameSize.width)
        let newPageOffset = CGPoint(x: lastPage * self.frame.size.width, y: 0)
        
        self.setContentOffset(newPageOffset, animated: false)
        
        lastFrameSize = self.frame.size
    }

}
