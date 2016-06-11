//
//  Extensions.swift
//  Example_ProductBrowser
//
//  Created by asdfgh1 on 11/06/2016.
//  Copyright © 2016 rshev. All rights reserved.
//

import Foundation
import RxSwift

func printl(message: Any? = nil, filename: String = #file, line: Int = #line, function: String = #function) {
    #if DEBUG
        print("\((filename as NSString).lastPathComponent):\(line) \(function)", terminator: "")
        if let message = message {
            print(":\r\(message)")
        } else {
            print("")
        }
    #endif
}


extension Array {
    
    subscript (safe safeIndex: Int) -> Element? {
        return self.indices ~= safeIndex ? self[safeIndex] : nil
    }
    
}


extension Disposable {
    
    /// for use inside closures with [weak self]. disposed instanteously if bag is nil
    public func addDisposableToBagIfItsStillNotDisposed(bag: RxSwift.DisposeBag?) {
        guard let bag = bag else {
            self.dispose()
            return
        }
        self.addDisposableTo(bag)
    }
    
}
