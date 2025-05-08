//
//    HistoryDetailResponse.swift
//
//    Create by MacPro3 on 12/9/2018
//    Copyright © 2018. All rights reserved.


import Foundation


struct HistoryDetailResponse : Codable{

    var message : String = ""
    var startTripToEndTripLocations : [[Double]] = [[0.0]]
    var success : Bool = false
    var trip : InvoiceTrip = InvoiceTrip.init()
    var tripservice : InvoiceTripService = InvoiceTripService.init()
    var user : HistoryUserDetail = HistoryUserDetail.init()
    
    
    enum CodingKeys: String, CodingKey {
        case message = "message"
        case startTripToEndTripLocations = "startTripToEndTripLocations"
        case success = "success"
        case trip = "trip"
        case tripservice = "tripservice"
        case user = "user"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        message = try values.decodeIfPresent(String.self, forKey: .message) ?? ""
       
        success = try values.decodeIfPresent(Bool.self, forKey: .success) ?? false
        trip = try values.decodeIfPresent(InvoiceTrip.self, forKey: .trip) ?? InvoiceTrip.init()
        tripservice = try values.decodeIfPresent(InvoiceTripService.self, forKey: .tripservice) ?? InvoiceTripService.init()
        
        user = try values.decodeIfPresent(HistoryUserDetail.self, forKey: .user) ?? HistoryUserDetail.init()
        startTripToEndTripLocations = try values.decodeIfPresent([[Double]].self, forKey: .startTripToEndTripLocations) ?? [[0.0]]
    }

    init() {}
}
