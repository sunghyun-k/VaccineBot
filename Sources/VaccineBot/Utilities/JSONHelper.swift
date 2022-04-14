//
//  File.swift
//  
//
//  Created by 김성현 on 2021/07/17.
//

import Foundation

extension Data {
    var dict: [String: Any]? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []) else {
            return nil
        }
        return object as? [String: Any]
    }
    var array: [String]? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []) else {
            return nil
        }
        return object as? [String]
    }
    var jsonParsed: Any? {
        return try? JSONSerialization.jsonObject(with: self, options: [])
    }
}

extension Array where Element == String {
    var jsonData: Data? {
        return try? JSONSerialization.data(withJSONObject: self, options: [])
    }
}
