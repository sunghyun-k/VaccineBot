//
//  File.swift
//  
//
//  Created by 김성현 on 2021/07/22.
//

import Foundation

extension Date {
    
    var timestamp: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: self)
    }
    
}
