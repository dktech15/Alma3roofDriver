//
//	FareEstimateResponse.swift
//
//	Create by MacPro3 on 20/9/2018
//	Copyright © 2018. All rights reserved.


import Foundation

struct FareEstimateResponse : Codable {
    
    var basePrice : Double = 0.0
    var distance : String = ""
    var estimatedFare : Double = 0.0
    var isMinFareUsed : Int = 0
    var message : String = ""
    var pricePerUnitTime : Int = 0
    var success : Bool = false
    var time : Double = 0.0
    var tripType : String = ""
    var userMiscellaneousFee : Double = 0.0
    var userTaxFee : Double = 0.0
    var pricePerUnitDistance : Double = 0.0
    
    enum CodingKeys: String, CodingKey {
        case basePrice = "base_price"
        case distance = "distance"
        case estimatedFare = "estimated_fare"
        case isMinFareUsed = "is_min_fare_used"
        case message = "message"
        case pricePerUnitDistance = "price_per_unit_distance"
        case pricePerUnitTime = "price_per_unit_time"
        case success = "success"
        case time = "time"
        case tripType = "trip_type"
        case userMiscellaneousFee = "user_miscellaneous_fee"
        case userTaxFee = "user_tax_fee"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        basePrice = try values.decodeIfPresent(Double.self, forKey: .basePrice) ?? 0.0
        distance = try values.decodeIfPresent(String.self, forKey: .distance) ?? ""
        estimatedFare = try values.decodeIfPresent(Double.self, forKey: .estimatedFare) ?? 0.0
        isMinFareUsed = try values.decodeIfPresent(Int.self, forKey: .isMinFareUsed) ?? 0
        message = try values.decodeIfPresent(String.self, forKey: .message) ?? ""
        pricePerUnitTime = try values.decodeIfPresent(Int.self, forKey: .pricePerUnitTime) ?? 0
        success = try values.decodeIfPresent(Bool.self, forKey: .success) ?? false
        time = try values.decodeIfPresent(Double.self, forKey: .time) ?? 0.0
        tripType = try values.decodeIfPresent(String.self, forKey: .tripType) ?? ""
        userMiscellaneousFee = try values.decodeIfPresent(Double.self, forKey: .userMiscellaneousFee) ?? 0.0
        userTaxFee = try values.decodeIfPresent(Double.self, forKey: .userTaxFee) ?? 0.0

        do {
            if let priceUnitDistance = try values.decodeIfPresent(Double.self, forKey: .pricePerUnitDistance) {
                pricePerUnitDistance = priceUnitDistance
            } else {
                pricePerUnitDistance = try values.decodeIfPresent(String.self, forKey: .pricePerUnitDistance)?.toDouble() ?? 0.0
            }
        } catch {
            pricePerUnitDistance = try values.decodeIfPresent(String.self, forKey: .pricePerUnitDistance)?.toDouble() ?? 0.0
        }
    }
}
