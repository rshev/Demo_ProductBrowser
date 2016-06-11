//
//  CatManager.swift
//  Example_ProductBrowser
//
//  Created by asdfgh1 on 11/06/2016.
//  Copyright © 2016 rshev. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class CatManager {
    static let sharedManager = CatManager()
    private init() {
        requestSections()
    }
    
    private let disposeBag = DisposeBag()
    
    private let _sectionMen: Variable<Section?> = Variable(nil)
    var sectionMen: Driver<Section?> {
        return _sectionMen.asDriver()
    }
    private let _sectionWomen: Variable<Section?> = Variable(nil)
    var sectionWomen: Driver<Section?> {
        return _sectionWomen.asDriver()
    }
    
    private func requestSections() {
        Backend.requestSection(type: .Men).subscribeNext { (section) in
            self._sectionMen.value = section
        }.addDisposableTo(disposeBag)
        
        Backend.requestSection(type: .Women).subscribeNext { (section) in
            self._sectionWomen.value = section
        }.addDisposableTo(disposeBag)
    }
    
}
