//
//	InvoiceTripservice.swift
//
//	Create by MacPro3 on 4/10/2018
//	Copyright © 2018. All rights reserved.


import Foundation

struct InvoiceTripService : Codable {
    
    var v : Int = 0
    var id : String = ""
    var basePrice : Double = 0.0
    var basePriceDistance : Double = 0.0
    var basePriceTime : Double = 0.0
    var cancellationFee : Double = 0.0
    var carRentalIds : [String] = []
    var cityId : String = ""
    var createdAt : String = ""
    var isCarRentalBusiness : Int = 0
    var isSurgeHours : Int = 0
    var maxSpace : Int = 0
    var minFare : Double = 0.0
    var priceForTotalTime : Double = 0.0
    var priceForWaitingTime : Double = 0.0
    var pricePerUnitDistance : Double = 0.0
    var providerMiscellaneousFee : Double = 0.0
    var providerProfit : Double = 0.0
    var providerTax : Double = 0.0
    var serviceTypeId : String = ""
    var serviceTypeName : String = ""
    var surgeEndHour : Int = 0
    var surgeMultiplier : Double = 0.0
    var richAreaSurgeMultiplier : Double!
    var surgeStartHour : Int = 0
    var tax : Double = 0.0
    var typename : String = ""
    var updatedAt : String = ""
    var userMiscellaneousFee : Double = 0.0
    var userTax : Double = 0.0
    var waitingTimeStartAfterMinute : Int = 0
    var is_use_distance_slot_calculation: Bool!
    var distance_slot_price_setting: [SelectedSlot]!
    
    enum CodingKeys: String, CodingKey {
        case v = "__v"
        case id = "_id"
        case basePrice = "base_price"
        case basePriceDistance = "base_price_distance"
        case basePriceTime = "base_price_time"
        case cancellationFee = "cancellation_fee"
        case carRentalIds = "car_rental_ids"
        case cityId = "city_id"
        case createdAt = "created_at"
        case isCarRentalBusiness = "is_car_rental_business"
        case isSurgeHours = "is_surge_hours"
        case maxSpace = "max_space"
        case minFare = "min_fare"
        case priceForTotalTime = "price_for_total_time"
        case priceForWaitingTime = "price_for_waiting_time"
        case pricePerUnitDistance = "price_per_unit_distance"
        case providerMiscellaneousFee = "provider_miscellaneous_fee"
        case providerProfit = "provider_profit"
        case providerTax = "provider_tax"
        case serviceTypeId = "service_type_id"
        case serviceTypeName = "service_type_name"
        case surgeEndHour = "surge_end_hour"
        case surgeMultiplier = "surge_multiplier"
        case surgeStartHour = "surge_start_hour"
        case richAreaSurgeMultiplier = "rich_area_surge_multiplier"
        case tax = "tax"
        case typename = "typename"
        case updatedAt = "updated_at"
        case userMiscellaneousFee = "user_miscellaneous_fee"
        case userTax = "user_tax"
        case waitingTimeStartAfterMinute = "waiting_time_start_after_minute"
        case is_use_distance_slot_calculation = "is_use_distance_slot_calculation"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        v = try values.decodeIfPresent(Int.self, forKey: .v) ?? 0
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? ""
        basePrice = try values.decodeIfPresent(Double.self, forKey: .basePrice) ?? 0.0
        basePriceDistance = try values.decodeIfPresent(Double.self, forKey: .basePriceDistance) ?? 0.0
        basePriceTime = try values.decodeIfPresent(Double.self, forKey: .basePriceTime) ?? 0.0
        cancellationFee = try values.decodeIfPresent(Double.self, forKey: .cancellationFee) ?? 0.0
        carRentalIds = try values.decodeIfPresent([String].self, forKey: .carRentalIds) ?? []
        cityId = try values.decodeIfPresent(String.self, forKey: .cityId) ?? ""
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt) ?? ""
        isCarRentalBusiness = try values.decodeIfPresent(Int.self, forKey: .isCarRentalBusiness) ?? 0
        isSurgeHours = try values.decodeIfPresent(Int.self, forKey: .isSurgeHours) ?? 0
        maxSpace = try values.decodeIfPresent(Int.self, forKey: .maxSpace) ?? 0
        minFare = try values.decodeIfPresent(Double.self, forKey: .minFare) ?? 0.0
        priceForTotalTime = try values.decodeIfPresent(Double.self, forKey: .priceForTotalTime) ?? 0.0
        richAreaSurgeMultiplier = try values.decodeIfPresent(Double.self, forKey: .richAreaSurgeMultiplier)
        priceForWaitingTime = try values.decodeIfPresent(Double.self, forKey: .priceForWaitingTime) ?? 0.0
        pricePerUnitDistance = try values.decodeIfPresent(Double.self, forKey: .pricePerUnitDistance) ?? 0.0
        providerMiscellaneousFee = try values.decodeIfPresent(Double.self, forKey: .providerMiscellaneousFee) ?? 0.0
        providerProfit = try values.decodeIfPresent(Double.self, forKey: .providerProfit) ?? 0.0
        providerTax = try values.decodeIfPresent(Double.self, forKey: .providerTax) ?? 0.0
        serviceTypeId = try values.decodeIfPresent(String.self, forKey: .serviceTypeId) ?? ""
        serviceTypeName = try values.decodeIfPresent(String.self, forKey: .serviceTypeName) ?? ""
        surgeEndHour = try values.decodeIfPresent(Int.self, forKey: .surgeEndHour) ?? 0
        surgeMultiplier = try values.decodeIfPresent(Double.self, forKey: .surgeMultiplier) ?? 0.0
        surgeStartHour = try values.decodeIfPresent(Int.self, forKey: .surgeStartHour) ?? 0
        tax = try values.decodeIfPresent(Double.self, forKey: .tax) ?? 0.0
        typename = try values.decodeIfPresent(String.self, forKey: .typename) ?? ""
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt) ?? ""
        userMiscellaneousFee = try values.decodeIfPresent(Double.self, forKey: .userMiscellaneousFee) ?? 0.0
        userTax = try values.decodeIfPresent(Double.self, forKey: .userTax) ?? 0.0
        waitingTimeStartAfterMinute = try values.decodeIfPresent(Int.self, forKey: .waitingTimeStartAfterMinute) ?? 0
        is_use_distance_slot_calculation = try values.decodeIfPresent(Bool.self, forKey: .is_use_distance_slot_calculation) ?? false
    
    }
    
    init() {

    }
}

class SelectedSlot: Model {
    
    var base_price : Double!
    var to : Double!
    var from : Double!
    var isEdit : Bool!
   
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        base_price = (dictionary["base_price"] as? Double) ?? 0.0
        
        if dictionary["to"] is Double {
            to = (dictionary["to"] as? Double) ?? 0.0
        } else if dictionary["to"] is String {
            to = Double(dictionary["to"] as? String ?? "0.00") ?? 0.0
        }
        
        if dictionary["from"] is Double {
            from = (dictionary["from"] as? Double) ?? 0.0
        } else if dictionary["from"] is String {
            from = Double(dictionary["from"] as? String ?? "0.00") ?? 0.0
        }
        isEdit = (dictionary["isEdit"] as? Bool) ?? false
    }
    
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        
        if base_price != nil{
            dictionary["base_price"] = base_price
        }
        if to != nil{
            dictionary["to"] = to
        }
        
        if from != nil{
            dictionary["from"] = from
        }
        
        if isEdit != nil{
            dictionary["isEdit"] = isEdit
        }
        return dictionary
    }
}
