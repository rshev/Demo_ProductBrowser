//
//  MenuViewModel.swift
//  Example_ProductBrowser
//
//  Created by asdfgh1 on 11/06/2016.
//  Copyright © 2016 rshev. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol MenuViewModelDelegate: class {
    func refresh()
}

class MenuViewModel {
    
    weak var delegate: MenuViewModelDelegate?
    
    private let _refreshTrigger = Variable()
    var refreshTrigger$: Driver<Void> {
        return _refreshTrigger.asDriver()
    }
    
    var selectedSectionNumber = 0
    
    var sectionNames: [String] {
        return CatManager.sharedManager.sections.map { $0.title }
    }
    
    var sectionCategoryNames: [String] {
        return CatManager.sharedManager.sections[selectedSectionNumber].categories.map { $0.name }
    }
    
    func selectSectionNumber(section: Int) {
        selectedSectionNumber = section
        delegate?.refresh()
    }

}
