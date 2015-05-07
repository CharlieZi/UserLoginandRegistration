//
//  Regex.swift
//  UserLoginandRegistration
//
//  Created by HuCharlie on 4/17/15.
//  Copyright (c) 2015 HuCharlie. All rights reserved.
//

import Foundation


struct RegexHelper {
    let regex: NSRegularExpression?
    
    init(_ pattern: String) {
        var error: NSError?
        regex = NSRegularExpression(pattern: pattern,
            options: .CaseInsensitive,
            error: &error)
    }
    
    func match(input: String) -> Bool {
        if let matches = regex?.matchesInString(input,
            options: nil,
            range: NSMakeRange(0, count(input))) {
                return matches.count > 0
        } else {
            return false
        }
    }
}