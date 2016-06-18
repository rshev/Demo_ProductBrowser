//
//  SelectableButton.swift
//  Example_ProductBrowser
//
//  Created by asdfgh1 on 17/06/2016.
//  Copyright © 2016 rshev. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SelectableButton: UIButton {

    private let underlineView = UIView()
    
    // trick to execute this one time on the variable initialization. invokes setup() method just because Xcode autocompletion breaks inside this closure.
    private lazy var oneTimeSetup: Void = {
        self.setup()
    }()
    
    private func setup() {
        underlineView.backgroundColor = UIColor.blackColor()
        underlineView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(underlineView)
        underlineView.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor).active = true
        underlineView.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor).active = true
        underlineView.trailingAnchor.constraintEqualToAnchor(self.trailingAnchor).active = true
        underlineView.heightAnchor.constraintEqualToConstant(6).active = true
        applyUnderline()
    }
    
    override func layoutSubviews() {
        // invoke setup one time here on the first layoutSubviews() invokation
        _ = oneTimeSetup
        super.layoutSubviews()
    }

    var underlined = false {
        didSet {
            applyUnderline()
        }
    }
    
    private func applyUnderline() {
        UIView.animateWithDuration(0.25, animations: { [weak self] in
            self?.underlineView.alpha = self?.underlined == true ? 1 : 0
        })
    }
    
}
