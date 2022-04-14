//
//  StringHelper.swift
//  
//
//  Created by 김성현 on 2021/07/13.
//

import Foundation

extension String {
    subscript(index: Int) -> Character {
        return self[self.index(startIndex, offsetBy: index)]
    }

    subscript(range: Range<Int>) -> String.SubSequence {
        return self[self.index(startIndex, offsetBy: range.lowerBound)..<self.index(startIndex, offsetBy: range.upperBound)]
    }
}

extension Data {
    var stringUtf8: String? {
        return String(data: self, encoding: .utf8)
    }
}
