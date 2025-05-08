//
//	HistoryTrip.swift
//
//	Create by MacPro3 on 12/9/2018
//	Copyright © 2018. All rights reserved.

import Foundation

struct HistoryTrip : Codable {
    
    var id : String = ""
    var currency : String = ""
    var currencycode :String = ""
    var currentProvider : String = ""
    var destinationAddress : String = ""
    var destinationAddresses : [DestinationAddresses] = []
    var firstName : String = ""
    var invoiceNumber : String = ""
    var isProviderRated : Int = 0
    var isTripCancelledByProvider : Int = 0
    var isTripCancelledByUser : Int = 0
    var isTripCancelled : Int = 0
    var isTripCompleted : Int = 0
    var isUserRated : Int = 0
    var lastName : String = ""
    var picture : String = ""
    var providerServiceFees : Double = 0.0
    var providerTripEndTime : String = ""
    var sourceAddress : String = ""
    var timezone : String = ""
    var total : Double = 0.0
    var totalDistance : Double = 0.0
    var totalTime : Double = 0.0
    var tripId : String = ""
    var uniqueId : Int = 0
    var unit : Int = 0
    var userCreateTime : String = ""

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case currency = "currency"
        case currencycode = "currencycode"
        case currentProvider = "current_provider"
        case destinationAddress = "destination_address"
        case firstName = "first_name"
        case invoiceNumber = "invoice_number"
        case isProviderRated = "is_provider_rated"
        case isTripCancelledByProvider = "is_trip_cancelled_by_provider"
        case isTripCancelledByUser = "is_trip_cancelled_by_user"
        case isTripCancelled = "is_trip_cancelled"
        case isTripCompleted = "is_trip_completed"
        case isUserRated = "is_user_rated"
        case lastName = "last_name"
        case picture = "picture"
        case providerServiceFees = "provider_service_fees"
        case providerTripEndTime = "provider_trip_end_time"
        case sourceAddress = "source_address"
        case timezone = "timezone"
        case total = "total"
        case totalDistance = "total_distance"
        case totalTime = "total_time"
        case tripId = "trip_id"
        case uniqueId = "unique_id"
        case unit = "unit"
        case userCreateTime = "user_create_time"
        case destinationAddresses = "destination_addresses"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? ""
        currency = try values.decodeIfPresent(String.self, forKey: .currency) ?? ""
        currencycode = try values.decodeIfPresent(String.self, forKey: .currencycode) ?? ""
        currentProvider = try values.decodeIfPresent(String.self, forKey: .currentProvider) ?? ""
        destinationAddress = try values.decodeIfPresent(String.self, forKey: .destinationAddress) ?? ""
        firstName = try values.decodeIfPresent(String.self, forKey: .firstName) ?? ""
        invoiceNumber = try values.decodeIfPresent(String.self, forKey: .invoiceNumber) ?? ""
        isProviderRated = try values.decodeIfPresent(Int.self, forKey: .isProviderRated) ?? 0
        isTripCancelledByProvider = try values.decodeIfPresent(Int.self, forKey: .isTripCancelledByProvider) ?? 0
        isTripCancelledByUser = try values.decodeIfPresent(Int.self, forKey: .isTripCancelledByUser) ?? 0
        isTripCancelled = try values.decodeIfPresent(Int.self, forKey: .isTripCancelled) ?? 0
        isTripCompleted = try values.decodeIfPresent(Int.self, forKey: .isTripCompleted) ?? 0
        isUserRated = try values.decodeIfPresent(Int.self, forKey: .isUserRated) ?? 0
        lastName = try values.decodeIfPresent(String.self, forKey: .lastName) ?? ""
        picture = try values.decodeIfPresent(String.self, forKey: .picture) ?? ""
        providerServiceFees = try values.decodeIfPresent(Double.self, forKey: .providerServiceFees) ?? 0.0
        providerTripEndTime = try values.decodeIfPresent(String.self, forKey: .providerTripEndTime) ?? ""
        sourceAddress = try values.decodeIfPresent(String.self, forKey: .sourceAddress) ?? ""
        timezone = try values.decodeIfPresent(String.self, forKey: .timezone) ?? ""
        total = try values.decodeIfPresent(Double.self, forKey: .total) ?? 0.0
        totalDistance = try values.decodeIfPresent(Double.self, forKey: .totalDistance) ?? 0.0
        totalTime = try values.decodeIfPresent(Double.self, forKey: .totalTime) ?? 0.0
        tripId = try values.decodeIfPresent(String.self, forKey: .tripId) ?? ""
        uniqueId = try values.decodeIfPresent(Int.self, forKey: .uniqueId) ?? 0
        unit = try values.decodeIfPresent(Int.self, forKey: .unit) ?? 0
        userCreateTime = try values.decodeIfPresent(String.self, forKey: .userCreateTime) ?? ""
        destinationAddresses = try values.decodeIfPresent([DestinationAddresses].self, forKey: .destinationAddresses) ?? []
    }
}
