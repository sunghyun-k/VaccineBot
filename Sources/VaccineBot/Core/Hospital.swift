// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let hospital = try? newJSONDecoder().decode(Hospital.self, from: jsonData)

import Foundation

// MARK: - Hospital
struct Hospital: Decodable {
    let id: String
    let roadAddress: String
    let address: String
    let businessHours: String
    let commonAddress: String
    let name: String
    let vaccineQuantity: VaccineTotalQuantity?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case roadAddress = "roadAddress"
        case address = "address"
        case businessHours = "businessHours"
        case commonAddress = "commonAddress"
        case name = "name"
        case vaccineQuantity = "vaccineQuantity"
    }
}

// MARK: - VaccineTotalQuantity
struct VaccineTotalQuantity: Decodable {
    let endTime: String?
    let totalQuantity: Int
    let totalQuantityStatus: QuantityStatus
    let list: [VaccineQuantity]
    let startTime: String?
    let vaccineOrganizationCode: String

    enum CodingKeys: String, CodingKey {
        case endTime = "endTime"
        case totalQuantity = "totalQuantity"
        case totalQuantityStatus = "totalQuantityStatus"
        case list = "list"
        case startTime = "startTime"
        case vaccineOrganizationCode = "vaccineOrganizationCode"
    }
}

// MARK: - VaccineQuantity
struct VaccineQuantity: Decodable {
    let quantity: Int
    let quantityStatus: QuantityStatus
    let vaccineType: String

    enum CodingKeys: String, CodingKey {
        case quantity = "quantity"
        case quantityStatus = "quantityStatus"
        case vaccineType = "vaccineType"
    }
}

enum QuantityStatus: String, Decodable {
    case waiting
    case plenty
    case some
    case few
    case empty
    case closed
    
    var description: String {
        switch self {
        case .waiting: return "대기중"
        case .plenty: return "충분히 있음"
        case .some: return "조금 있음"
        case .few: return "매우 적음"
        case .empty: return "없음"
        case .closed: return "마감"
        }
    }
}




extension Hospital {
    var reservationURL: URL? {
        
        guard let vaccine = vaccineQuantity else { return nil }
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "v-search.nid.naver.com"
        components.path = "/reservation"
        components.queryItems = [
            .init(name: "orgCd", value: vaccine.vaccineOrganizationCode),
            .init(name: "sid", value: id)
        ]
        return components.url!
    }
    
    var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "m.place.naver.com"
        components.path = "/hospital/\(id)/home"
        return components.url!
    }
}
