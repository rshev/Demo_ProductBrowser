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
    
    private let _sections = Variable([Section]())
    var sections: [Section] {
        return _sections.value
    }
    var sections$: Observable<[Section]> {
        return _sections.asObservable()
    }
    
    private func requestSections() {
        Backend.requestSection(type: .Men).subscribeNext { (section) in
            self._sections.value.append(section)
        }.addDisposableTo(disposeBag)
        
        Backend.requestSection(type: .Women).subscribeNext { (section) in
            self._sections.value.append(section)
        }.addDisposableTo(disposeBag)
    }
    
}
