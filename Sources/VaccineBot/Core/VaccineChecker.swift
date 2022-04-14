//
//  VaccineChecker_Naver.swift
//  
//
//  Created by 김성현 on 2021/07/22.
//

import Foundation

struct Coordinate: Codable {
    var x, y: String
}

enum VaccineCheckerError: Error {
    case httpResponseError(request: URLRequest, response: HTTPURLResponse, data: Data?)
    case noData(request: URLRequest, response: HTTPURLResponse)
    case jsonParsingError(request: URLRequest, response: HTTPURLResponse, data: Data, error: Error)
}
extension VaccineCheckerError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .httpResponseError(let request, let response, let data):
            return "HTTP 응답 오류.\n요청: '\(request)'\n응답: '\(response)'\n데이터: '\(data?.stringUtf8 ?? "")'"
        case .noData(let request, let response):
            return "데이터 없음.\n요청: '\(request)'\n응답: '\(response.statusCode)'"
        case .jsonParsingError(let request, let response, let data, let error):
            return "JSON 파싱 오류.\n요청: '\(request)'\n응답: '\(response.statusCode)'\n데이터: '\(data.stringUtf8 ?? "")'\n오류: \(error)"
        }
    }
}

class VaccineChecker {
    
    private let fetcher = DataFetcher()
    private let dataManager: DataManager
    private var coordinates = [Coordinate]()
    
    init() {
        dataManager = DataManager(defaultDirectory: "/Sources/VaccineBot/Data/")
        let data = try! dataManager.data(atPath: "coordinates.json")
        coordinates = try! JSONDecoder().decode([Coordinate].self, from: data)
    }
    
    func fetchHospitals(completionHandler: @escaping ([Hospital], Error?) -> Void) {
        
        let requests = coordinates.map { coordinate in
            vaccineURLRequest(x: coordinate.x, y: coordinate.y)
        }
        
        requests.forEach { request in
            
            fetcher.fetch(from: request) { data, response, error in
                guard error == nil else {
                    completionHandler([], error!)
                    return
                }
                
                guard (response as! HTTPURLResponse).statusCode == 200 else {
                    completionHandler(
                        [],
                        VaccineCheckerError.httpResponseError(
                            request: request,
                            response: response as! HTTPURLResponse,
                            data: data
                        )
                    )
                    return
                }
                
                
                guard let data = data else {
                    completionHandler(
                        [],
                        VaccineCheckerError.noData(
                            request: request,
                            response: response as! HTTPURLResponse
                        )
                    )
                    return
                }
                
                let hospitalResponse: HospitalResponse
                do {
                    hospitalResponse = try JSONDecoder().decode(HospitalResponse.self, from: data)
                } catch {
                    completionHandler(
                        [],
                        VaccineCheckerError.jsonParsingError(
                            request: request,
                            response: response as! HTTPURLResponse,
                            data: data,
                            error: error
                        )
                    )
                    return
                }
                completionHandler(hospitalResponse[0].data.rests.businesses.items, nil)
            }
        }
    }
    
    
    private func vaccineURLRequest(x: String, y: String) -> URLRequest {
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.place.naver.com"
        components.path = "/graphql"
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(payload(x: x, y: y))
        return request
    }
    
    private func payload(x: String, y: String) -> Payload {
        
        let businessesInput = BusinessesInput(start: 0, display: 100, deviceType: "mobile", x: x, y: y, sortingOrder: "distance")
        let input = Input(keyword: "코로나백신위탁의료기관", x: x, y: y)
        
        let variables = Variables(input: input, businessesInput: businessesInput, isNmap: false, isBounds: false)
        let query = "query vaccineList($input: RestsInput, $businessesInput: RestsBusinessesInput, $isNmap: Boolean!, $isBounds: Boolean!) {\n  rests(input: $input) {\n    businesses(input: $businessesInput) {\n      total\n      vaccineLastSave\n      isUpdateDelayed\n      items {\n        id\n        name\n        dbType\n        phone\n        virtualPhone\n        hasBooking\n        hasNPay\n        bookingReviewCount\n        description\n        distance\n        commonAddress\n        roadAddress\n        address\n        imageUrl\n        imageCount\n        tags\n        distance\n        promotionTitle\n        category\n        routeUrl\n        businessHours\n        x\n        y\n        imageMarker @include(if: $isNmap) {\n          marker\n          markerSelected\n          __typename\n        }\n        markerLabel @include(if: $isNmap) {\n          text\n          style\n          __typename\n        }\n        isDelivery\n        isTakeOut\n        isPreOrder\n        isTableOrder\n        naverBookingCategory\n        bookingDisplayName\n        bookingBusinessId\n        bookingVisitId\n        bookingPickupId\n        vaccineOpeningHour {\n          isDayOff\n          standardTime\n          __typename\n        }\n        vaccineQuantity {\n          totalQuantity\n          totalQuantityStatus\n          startTime\n          endTime\n          vaccineOrganizationCode\n          list {\n            quantity\n            quantityStatus\n            vaccineType\n            __typename\n          }\n          __typename\n        }\n        __typename\n      }\n      optionsForMap @include(if: $isBounds) {\n        maxZoom\n        minZoom\n        includeMyLocation\n        maxIncludePoiCount\n        center\n        __typename\n      }\n      __typename\n    }\n    queryResult {\n      keyword\n      vaccineFilter\n      categories\n      region\n      isBrandList\n      filterBooking\n      hasNearQuery\n      isPublicMask\n      __typename\n    }\n    __typename\n  }\n}\n"
        
        return [PayloadElement(operationName: "vaccineList", variables: variables, query: query)]
    }
    
}
