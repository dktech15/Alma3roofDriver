//
//	TypeDetail.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct TypeDetail : Codable {
    
    var basePrice : Double = 0.0
    var basePriceDistance : Double = 0.0
    var countryId : String = ""
    var currency : String = ""
    var distancePrice : Double = 0.0
    var isAutoTransfer : Bool = false
    var isCheckProviderWalletAmountForReceivedCashRequest : Bool = false
    var isSurgeHours : Int = 0
    var mapPinImageUrl : String = ""
    var providerMinWalletAmountSetForReceivedCashRequest : Double = 0.0
    var serverTime : String = ""
    var surgeEndHour : Int = 0
    var surgeStartHour : Int = 0
    var timePrice : Double = 0.0
    var timezone : String = ""
    var typeImageUrl : String = ""
    var typeid : String = ""
    var typename : String = ""
    var unit : Int = 0
    var serviceType:Int = 0
    var description: String = ""
    
    enum CodingKeys: String, CodingKey {
        case description = "description"
        case basePrice = "base_price"
        case basePriceDistance = "base_price_distance"
        case countryId = "country_id"
        case currency = "currency"
        case distancePrice = "distance_price"
        case isAutoTransfer = "is_auto_transfer"
        case isCheckProviderWalletAmountForReceivedCashRequest = "is_check_provider_wallet_amount_for_received_cash_request"
        case isSurgeHours = "is_surge_hours"
        case mapPinImageUrl = "map_pin_image_url"
        case providerMinWalletAmountSetForReceivedCashRequest = "provider_min_wallet_amount_set_for_received_cash_request"
        case serverTime = "server_time"
        case surgeEndHour = "surge_end_hour"
        case surgeStartHour = "surge_start_hour"
        case timePrice = "time_price"
        case timezone = "timezone"
        case typeImageUrl = "type_image_url"
        case typeid = "typeid"
        case typename = "typename"
        case unit = "unit"
        case serviceType = "service_type"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        basePrice = try values.decodeIfPresent(Double.self, forKey: .basePrice) ?? 0.0
        basePriceDistance = try values.decodeIfPresent(Double.self, forKey: .basePriceDistance) ?? 0.0
        countryId = try values.decodeIfPresent(String.self, forKey: .countryId) ?? ""
        currency = try values.decodeIfPresent(String.self, forKey: .currency) ?? ""
        distancePrice = try values.decodeIfPresent(Double.self, forKey: .distancePrice) ?? 0.0
        isAutoTransfer = try values.decodeIfPresent(Bool.self, forKey: .isAutoTransfer) ?? false
        isCheckProviderWalletAmountForReceivedCashRequest = try values.decodeIfPresent(Bool.self, forKey: .isCheckProviderWalletAmountForReceivedCashRequest) ?? false
        isSurgeHours = try values.decodeIfPresent(Int.self, forKey: .isSurgeHours) ?? 0
        mapPinImageUrl = try values.decodeIfPresent(String.self, forKey: .mapPinImageUrl) ?? ""
        providerMinWalletAmountSetForReceivedCashRequest = try values.decodeIfPresent(Double.self, forKey: .providerMinWalletAmountSetForReceivedCashRequest) ?? 0.0
        serverTime = try values.decodeIfPresent(String.self, forKey: .serverTime) ?? ""
        surgeEndHour = try values.decodeIfPresent(Int.self, forKey: .surgeEndHour) ?? 0
        surgeStartHour = try values.decodeIfPresent(Int.self, forKey: .surgeStartHour) ?? 0
        timePrice = try values.decodeIfPresent(Double.self, forKey: .timePrice) ?? 0.0
        timezone = try values.decodeIfPresent(String.self, forKey: .timezone) ?? ""
        typeImageUrl = try values.decodeIfPresent(String.self, forKey: .typeImageUrl) ?? ""
        typeid = try values.decodeIfPresent(String.self, forKey: .typeid) ?? ""
        typename = try values.decodeIfPresent(String.self, forKey: .typename) ?? ""
        unit = try values.decodeIfPresent(Int.self, forKey: .unit) ?? 0
        serviceType = try values.decodeIfPresent(Int.self, forKey: .serviceType) ?? 0
        description = try values.decodeIfPresent(String.self, forKey: .description) ?? ""
    }
    
    init() {}
}
