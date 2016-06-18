//
//  Extensions.swift
//  Example_ProductBrowser
//
//  Created by asdfgh1 on 11/06/2016.
//  Copyright © 2016 rshev. All rights reserved.
//

import Foundation

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
