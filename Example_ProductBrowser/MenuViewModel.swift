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

class MenuViewModel {
    
    private let _selectedSectionNumber = Variable(Int(0))
    var selectedSectionNumber$: Driver<Int> {
        return _selectedSectionNumber.asDriver().distinctUntilChanged()
    }
    
    var sectionNames$: Driver<[String]> {
        return CatManager.sharedManager.sections$.flatMap({ (sections) -> Driver<[String]> in
            return Driver.just(sections.map { $0.title })
        })
    }
    
    var sectionCategoryNames$: Driver<[String]> {
        let sectionNumber = _selectedSectionNumber.value
        return CatManager.sharedManager.sections$.flatMap({ (sections) -> Driver<[String]> in
            return Driver.just(sections[sectionNumber].categories.map { $0.name })
        })
    }
    
    init() {
        
    }
    
    func selectSectionNumber(section: Int) {
        _selectedSectionNumber.value = section
        
    }

}
