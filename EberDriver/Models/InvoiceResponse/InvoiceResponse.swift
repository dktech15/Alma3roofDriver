//
//	InvoiceResponse.swift
//
//	Create by MacPro3 on 4/10/2018
//	Copyright © 2018. All rights reserved.


import Foundation

struct InvoiceResponse : Codable

{

    var message : String = ""
    var success : Bool = false
    var trip : InvoiceTrip = InvoiceTrip.init()
    var tripservice : InvoiceTripService = InvoiceTripService.init()
    
    enum CodingKeys: String, CodingKey {
        case message = "message"
        case success = "success"
        case trip = "trip"
        case tripservice = "tripservice"
    }

    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        message = try values.decodeIfPresent(String.self, forKey: .message) ?? ""
        success = try values.decodeIfPresent(Bool.self, forKey: .success) ?? false
        trip = try! values.decodeIfPresent(InvoiceTrip.self, forKey: .trip)!
        tripservice = try values.decodeIfPresent(InvoiceTripService.self, forKey: .tripservice) ?? InvoiceTripService.init()
        
    }

    init() {}
}
