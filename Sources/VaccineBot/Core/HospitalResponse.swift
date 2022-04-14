//
//  File.swift
//  
//
//  Created by 김성현 on 2021/07/22.
//

import Foundation

// MARK: - HospitalResponse
struct HospitalResponseElement: Decodable {
    let data: DataStruct

    enum CodingKeys: String, CodingKey {
        case data = "data"
    }
}

// MARK: - DataClass
struct DataStruct: Decodable {
    let rests: Rests

    enum CodingKeys: String, CodingKey {
        case rests = "rests"
    }
}

// MARK: - Rests
struct Rests: Decodable {
    let businesses: Businesses

    enum CodingKeys: String, CodingKey {
        case businesses = "businesses"
    }
}

// MARK: - Businesses
struct Businesses: Decodable {
    let total: Int
    let vaccineLastSave: Int
    let isUpdateDelayed: Bool
    let items: [Hospital]

    enum CodingKeys: String, CodingKey {
        case total = "total"
        case vaccineLastSave = "vaccineLastSave"
        case isUpdateDelayed = "isUpdateDelayed"
        case items = "items"
    }
}

typealias HospitalResponse = [HospitalResponseElement]
