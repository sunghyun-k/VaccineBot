//
//  String+RegEx.swift
//  
//
//  Created by 김성현 on 2021/07/13.
//

import Foundation

extension String {
    
    /// 문자열에서 정규 표현식 매칭을 바로 사용합니다.
    /// - Parameter pattern: 정규표현식 패턴
    /// - Throws: 패턴이 유효하지 않을 경우 오류 발생
    /// - Returns: 매칭된 항목들이 담긴 배열, 첫번째는 매칭된 항목, 두번째 이후는 캡쳐그룹 항목, 매칭되지 않은 경우 빈 배열
    func matches(pattern: String) throws -> [String] {
        let regex = try NSRegularExpression(pattern: pattern)
        
        let matches = regex.matches(in: self, range: NSRange(startIndex..., in: self))
        
        guard !matches.isEmpty else {
            return []
        }
        
        var result = [String]()
        for i in 0..<matches[0].numberOfRanges {
            let rangeMatched = matches[0].range(at: i)
            let matched = (self as NSString).substring(with: rangeMatched)
            result.append(matched)
        }
        return result
    }
    
}
