//
//  DataManager.swift
//  
//
//  Created by 김성현 on 2021/07/16.
//

import Foundation

struct DataManager {
    
    private var localPath: String {
        #if os(Linux)
        return "./"
        #else
        return "/Volumes/docker/swift/Projects/VaccineBot/"
        #endif
    }
    
    var defaultDirectory: String = ""
    
    func data(atPath path: String) throws -> Data {
        let url = try localURL(path: path)
        return try Data(contentsOf: url)
    }
    
    func write(data: Data, to path: String) throws {
        let url = try localURL(path: path)
        try data.write(to: url)
    }
    
    private func localURL(path: String) throws -> URL {
        return URL.init(fileURLWithPath: localPath + defaultDirectory + path)
    }
}
