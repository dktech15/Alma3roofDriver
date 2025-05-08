//
//	RootClass.swift
//
//	Create by MacPro3 on 24/9/2018
//	Copyright © 2018. All rights reserved.


import Foundation

struct TripStatusResponse : Codable
{
    
    var countryPhoneCode : String = ""
    var mapPinImageUrl : String = ""
    var message : String = ""
    var phone : String = ""
    var support_phone_user : String = ""
    var user_type : Int = 0
    var priceForWaitingTime : Double = 0.0
    var success : Bool = false
    var totalWaitTime : Int = 0
    var trip : Trip = Trip.init()
    var waitingTimeStartAfterMinute : Int = 0
    var tripService:InvoiceTripService = InvoiceTripService.init()
    
    enum CodingKeys: String, CodingKey {
        case countryPhoneCode = "country_phone_code"
        case mapPinImageUrl = "map_pin_image_url"
        case message = "message"
        case phone = "phone"
        case support_phone_user = "support_phone_user"
        case user_type = "user_type"
        case priceForWaitingTime = "price_for_waiting_time"
        case success = "success"
        case totalWaitTime = "total_wait_time"
        case trip = "trip"
        case tripService = "tripservice"
        case waitingTimeStartAfterMinute = "waiting_time_start_after_minute"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        countryPhoneCode = try values.decodeIfPresent(String.self, forKey: .countryPhoneCode) ?? ""
        mapPinImageUrl = try values.decodeIfPresent(String.self, forKey: .mapPinImageUrl) ?? ""
        message = try values.decodeIfPresent(String.self, forKey: .message) ?? ""
        phone = try values.decodeIfPresent(String.self, forKey: .phone) ?? ""
        support_phone_user = try values.decodeIfPresent(String.self, forKey: .support_phone_user) ?? ""
        user_type = try values.decodeIfPresent(Int.self, forKey: .user_type) ?? 0
        priceForWaitingTime = try values.decodeIfPresent(Double.self, forKey: .priceForWaitingTime) ?? 0.0
        success = try values.decodeIfPresent(Bool.self, forKey: .success) ?? false
        totalWaitTime = try values.decodeIfPresent(Int.self, forKey: .totalWaitTime) ?? 0
        trip = try values.decodeIfPresent(Trip.self, forKey: .trip) ?? Trip.init()
        tripService = try values.decodeIfPresent(InvoiceTripService.self, forKey: .tripService) ?? InvoiceTripService.init()
        waitingTimeStartAfterMinute = try values.decodeIfPresent(Int.self, forKey: .waitingTimeStartAfterMinute) ?? 0
    }
    init() {}
}
