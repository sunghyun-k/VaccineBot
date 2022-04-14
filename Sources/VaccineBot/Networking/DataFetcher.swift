//
//  DataFetcher.swift
//  
//
//  Created by 김성현 on 2021/07/16.
//

import Foundation

struct DataFetcher {
    
    private let session: URLSession
    private var queue: OperationQueue = OperationQueue()
    
    init(session: URLSession = .shared) {
        self.session = session
        
        queue.maxConcurrentOperationCount = 1
    }
    
    func fetch(from url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        
        let operation = DownloadOperation(session: session, url: url, completionHandler: completionHandler)
        queue.addOperation(operation)
    }
    
    func fetch(from urlRequest: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        
        let operation = DownloadOperation(session: session, urlRequest: urlRequest, completionHandler: completionHandler)
        queue.addOperation(operation)
    }
}
