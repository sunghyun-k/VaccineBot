// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let payload = try? newJSONDecoder().decode(Payload.self, from: jsonData)

import Foundation

// MARK: - PayloadElement
struct PayloadElement: Encodable {
    let operationName: String
    let variables: Variables
    let query: String

    enum CodingKeys: String, CodingKey {
        case operationName = "operationName"
        case variables = "variables"
        case query = "query"
    }
}

// MARK: - Variables
struct Variables: Encodable {
    let input: Input
    let businessesInput: BusinessesInput
    let isNmap: Bool
    let isBounds: Bool

    enum CodingKeys: String, CodingKey {
        case input = "input"
        case businessesInput = "businessesInput"
        case isNmap = "isNmap"
        case isBounds = "isBounds"
    }
}

// MARK: - BusinessesInput
struct BusinessesInput: Encodable {
    let start: Int
    let display: Int
    let deviceType: String
    let x: String
    let y: String
    let sortingOrder: String

    enum CodingKeys: String, CodingKey {
        case start = "start"
        case display = "display"
        case deviceType = "deviceType"
        case x = "x"
        case y = "y"
        case sortingOrder = "sortingOrder"
    }
}

// MARK: - Input
struct Input: Encodable {
    let keyword: String
    let x: String
    let y: String

    enum CodingKeys: String, CodingKey {
        case keyword = "keyword"
        case x = "x"
        case y = "y"
    }
}

typealias Payload = [PayloadElement]
