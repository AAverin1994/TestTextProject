//
//  NSRegularExpression.swift
//  TestTextProject
//
//  Created by Andrey on 05.03.2024.
//

import Foundation

extension NSRegularExpression {
    func matches(_ string: String) -> Bool {
        let range = NSRange(location: 0, length: string.utf16.count)
        return firstMatch(in: string, options: [], range: range) != nil
    }
}
