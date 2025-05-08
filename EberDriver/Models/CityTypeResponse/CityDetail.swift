//
//	CityDetail.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct CityDetail : Codable {

	let v : Int?
	let id : String?
	let airportBusiness : Int?
	let cityLatLong : [Double]?
	let cityRadius : Int?
	let cityBusiness : Int?
	let cityLocations : [[Double]]?
	let citycode : String?
	let cityname : String?
	let countryid : String?
	let countryname : String?
	let createdAt : String?
	let dailyCronDate : String?
	let destinationCity : [String]?
	let fullCityname : String?
	let isBusiness : Int?
	let isCountryBusiness : Int?
	let isPromoApplyForCard : Int?
	let isPromoApplyForCash : Int?
	let isAskUserForFixedFare : Bool?
	let isCheckProviderWalletAmountForReceivedCashRequest : Bool?
	let isPaymentModeCard : Int?
	let isPaymentModeCash : Int?
    var isPaymentModeApplePay: Int = 0
	let isProviderEarningSetInWalletOnCashPayment : Bool?
	let isProviderEarningSetInWalletOnOtherPayment : Bool?
	let isUseCityBoundary : Bool?
	let paymentGateway : [Int]?
	let providerMinWalletAmountSetForReceivedCashRequest : Int?
	let timezone : String?
	let unit : Int?
	let updatedAt : String?
	let zipcode : String?
	let zoneBusiness : Int?
    var richAreaSurgeMultiplier : Double = 0.0

	enum CodingKeys: String, CodingKey {
		case v = "__v"
		case id = "_id"
		case airportBusiness = "airport_business"
		case cityLatLong = "cityLatLong"
		case cityRadius = "cityRadius"
		case cityBusiness = "city_business"
		case cityLocations = "city_locations"
		case citycode = "citycode"
		case cityname = "cityname"
		case countryid = "countryid"
		case countryname = "countryname"
        case richAreaSurgeMultiplier = "rich_area_surge_multiplier"
		case createdAt = "created_at"
		case dailyCronDate = "daily_cron_date"
		case destinationCity = "destination_city"
		case fullCityname = "full_cityname"
		case isBusiness = "isBusiness"
		case isCountryBusiness = "isCountryBusiness"
		case isPromoApplyForCard = "isPromoApplyForCard"
		case isPromoApplyForCash = "isPromoApplyForCash"
		case isAskUserForFixedFare = "is_ask_user_for_fixed_fare"
		case isCheckProviderWalletAmountForReceivedCashRequest = "is_check_provider_wallet_amount_for_received_cash_request"
		case isPaymentModeCard = "is_payment_mode_card"
		case isPaymentModeCash = "is_payment_mode_cash"
        case isPaymentModeApplePay = "is_payment_mode_apple_pay"
		case isProviderEarningSetInWalletOnCashPayment = "is_provider_earning_set_in_wallet_on_cash_payment"
		case isProviderEarningSetInWalletOnOtherPayment = "is_provider_earning_set_in_wallet_on_other_payment"
		case isUseCityBoundary = "is_use_city_boundary"
		case paymentGateway = "payment_gateway"
		case providerMinWalletAmountSetForReceivedCashRequest = "provider_min_wallet_amount_set_for_received_cash_request"
		case timezone = "timezone"
		case unit = "unit"
		case updatedAt = "updated_at"
		case zipcode = "zipcode"
		case zoneBusiness = "zone_business"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		v = try values.decodeIfPresent(Int.self, forKey: .v)
		id = try values.decodeIfPresent(String.self, forKey: .id)
		airportBusiness = try values.decodeIfPresent(Int.self, forKey: .airportBusiness)
		cityLatLong = try values.decodeIfPresent([Double].self, forKey: .cityLatLong)
		cityRadius = try values.decodeIfPresent(Int.self, forKey: .cityRadius)
		cityBusiness = try values.decodeIfPresent(Int.self, forKey: .cityBusiness)
		cityLocations = try values.decodeIfPresent([[Double]].self, forKey: .cityLocations)
		citycode = try values.decodeIfPresent(String.self, forKey: .citycode)
		cityname = try values.decodeIfPresent(String.self, forKey: .cityname)
		countryid = try values.decodeIfPresent(String.self, forKey: .countryid)
		countryname = try values.decodeIfPresent(String.self, forKey: .countryname)
		createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
		dailyCronDate = try values.decodeIfPresent(String.self, forKey: .dailyCronDate)
		destinationCity = try values.decodeIfPresent([String].self, forKey: .destinationCity)
		fullCityname = try values.decodeIfPresent(String.self, forKey: .fullCityname)
		isBusiness = try values.decodeIfPresent(Int.self, forKey: .isBusiness)
		isCountryBusiness = try values.decodeIfPresent(Int.self, forKey: .isCountryBusiness)
		isPromoApplyForCard = try values.decodeIfPresent(Int.self, forKey: .isPromoApplyForCard)
		isPromoApplyForCash = try values.decodeIfPresent(Int.self, forKey: .isPromoApplyForCash)
		isAskUserForFixedFare = try values.decodeIfPresent(Bool.self, forKey: .isAskUserForFixedFare)
		isCheckProviderWalletAmountForReceivedCashRequest = try values.decodeIfPresent(Bool.self, forKey: .isCheckProviderWalletAmountForReceivedCashRequest)
		isPaymentModeCard = try values.decodeIfPresent(Int.self, forKey: .isPaymentModeCard)
		isPaymentModeCash = try values.decodeIfPresent(Int.self, forKey: .isPaymentModeCash)
        isPaymentModeApplePay = try values.decodeIfPresent(Int.self, forKey: .isPaymentModeApplePay) ?? 0
		isProviderEarningSetInWalletOnCashPayment = try values.decodeIfPresent(Bool.self, forKey: .isProviderEarningSetInWalletOnCashPayment)
		isProviderEarningSetInWalletOnOtherPayment = try values.decodeIfPresent(Bool.self, forKey: .isProviderEarningSetInWalletOnOtherPayment)
		isUseCityBoundary = try values.decodeIfPresent(Bool.self, forKey: .isUseCityBoundary)
		paymentGateway = try values.decodeIfPresent([Int].self, forKey: .paymentGateway)
		providerMinWalletAmountSetForReceivedCashRequest = try values.decodeIfPresent(Int.self, forKey: .providerMinWalletAmountSetForReceivedCashRequest)
		timezone = try values.decodeIfPresent(String.self, forKey: .timezone)
		unit = try values.decodeIfPresent(Int.self, forKey: .unit)
		updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
		zipcode = try values.decodeIfPresent(String.self, forKey: .zipcode)
		zoneBusiness = try values.decodeIfPresent(Int.self, forKey: .zoneBusiness)
        richAreaSurgeMultiplier = try values.decodeIfPresent(Double.self, forKey: .richAreaSurgeMultiplier) ?? 0.0
	}
}
