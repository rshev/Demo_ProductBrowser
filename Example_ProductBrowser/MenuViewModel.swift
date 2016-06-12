//
//  MenuViewModel.swift
//  Example_ProductBrowser
//
//  Created by asdfgh1 on 11/06/2016.
//  Copyright © 2016 rshev. All rights reserved.
//

import Foundation

protocol MenuViewModelDelegate: class {
    func menuRefreshListOfCategories()
    func menuSelectSectionNumber(num: Int)
    func menuPassCategoryProductListViewModelFurther(viewModel: ProductListViewModel)
}

class MenuViewModel {
    
    weak var delegate: MenuViewModelDelegate?
    
    private var selectedSectionNumber = 0
    
    var sectionNames: [String] {
        return CatManager.sharedManager.sections.map { $0.title }
    }
    
    var sectionCategoryNames: [String] {
        return CatManager.sharedManager.sections[selectedSectionNumber].categories.map { $0.name }
    }
    
    func selectSectionNumber(section: Int) {
        selectedSectionNumber = section
        delegate?.menuRefreshListOfCategories()
        delegate?.menuSelectSectionNumber(section)
    }

    func selectCategoryAtRow(row: Int) {
        let category = CatManager.sharedManager.sections[selectedSectionNumber].categories[row]
        delegate?.menuPassCategoryProductListViewModelFurther(ProductListViewModel(category: category))
    }
    
}
