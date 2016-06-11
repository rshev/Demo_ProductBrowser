//
//  Moya+Extensions.swift
//  Example_ProductBrowser
//
//  Created by asdfgh1 on 11/06/2016.
//  Copyright © 2016 rshev. All rights reserved.
//

import Foundation
import RxSwift
import Moya

extension ObservableConvertibleType {
    
    func retryIfMoyaUnreachable() -> Observable<E> {
        return self.asObservable().catchError { error in
            if error is Moya.Error {
                printl(error)
                return self.asObservable().retry()
            } else {
                return Observable.error(error)
            }
        }
    }
    
}
