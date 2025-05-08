//
//	CarRentalList.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct CarRentalList : Codable {

	let v : Int?
	let id : String?
	let basePrice : Double?
	let basePriceDistance : Int?
	let basePriceTime : Int?
	let cancellationFee : Int?
	let carRentalIds : [String]?
	let cityname : String?
	let countryname : String?
	let createdAt : String?
	let isBuiesness : Int?
	let isCarRentalBusiness : Int?
	let isHide : Int?
	let isSurgeHours : Int?
	let isZone : Int?
	let maxSpace : Int?
	let minFare : Int?
	let priceForTotalTime : Double?
	let priceForWaitingTime : Int?
	let pricePerUnitDistance : Double?
	let providerMiscellaneousFee : Int?
	let providerProfit : Int?
	let providerTax : Int?
	let surgeEndHour : Int?
	
    var surgeMultiplier : Double!
    var richAreaSurgeMultiplier : Double!
	let surgeStartHour : Int?
	let tax : Int?
	let totalProviderInZoneQueue : [String]?
	let typeImage : String?
	let typename : String?
	let updatedAt : String?
	let userMiscellaneousFee : Int?
	let userTax : Int?
	let waitingTimeStartAfterMinute : Int?
	let zoneIds : [String]?


	enum CodingKeys: String, CodingKey {
		case v = "__v"
		case id = "_id"
		case basePrice = "base_price"
		case basePriceDistance = "base_price_distance"
		case basePriceTime = "base_price_time"
		case cancellationFee = "cancellation_fee"
		case carRentalIds = "car_rental_ids"
		case cityname = "cityname"
		case countryname = "countryname"
		case createdAt = "created_at"
		case isBuiesness = "is_buiesness"
		case isCarRentalBusiness = "is_car_rental_business"
		case isHide = "is_hide"
		case isSurgeHours = "is_surge_hours"
		case isZone = "is_zone"
		case maxSpace = "max_space"
		case minFare = "min_fare"
		case priceForTotalTime = "price_for_total_time"
		case priceForWaitingTime = "price_for_waiting_time"
		case pricePerUnitDistance = "price_per_unit_distance"
		case providerMiscellaneousFee = "provider_miscellaneous_fee"
		case providerProfit = "provider_profit"
		case providerTax = "provider_tax"
		case surgeEndHour = "surge_end_hour"
		case surgeMultiplier = "surge_multiplier"
        case richAreaSurgeMultiplier = "rich_area_surge_multiplier"
		case surgeStartHour = "surge_start_hour"
		case tax = "tax"
		case totalProviderInZoneQueue = "total_provider_in_zone_queue"
		case typeImage = "type_image"
		case typename = "typename"
		case updatedAt = "updated_at"
		case userMiscellaneousFee = "user_miscellaneous_fee"
		case userTax = "user_tax"
		case waitingTimeStartAfterMinute = "waiting_time_start_after_minute"
		case zoneIds = "zone_ids"
	}
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		v = try values.decodeIfPresent(Int.self, forKey: .v)
		id = try values.decodeIfPresent(String.self, forKey: .id)
		basePrice = try values.decodeIfPresent(Double.self, forKey: .basePrice)
		basePriceDistance = try values.decodeIfPresent(Int.self, forKey: .basePriceDistance)
		basePriceTime = try values.decodeIfPresent(Int.self, forKey: .basePriceTime)
		cancellationFee = try values.decodeIfPresent(Int.self, forKey: .cancellationFee)
		carRentalIds = try values.decodeIfPresent([String].self, forKey: .carRentalIds)
		cityname = try values.decodeIfPresent(String.self, forKey: .cityname)
		countryname = try values.decodeIfPresent(String.self, forKey: .countryname)
		createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
		isBuiesness = try values.decodeIfPresent(Int.self, forKey: .isBuiesness)
		isCarRentalBusiness = try values.decodeIfPresent(Int.self, forKey: .isCarRentalBusiness)
		isHide = try values.decodeIfPresent(Int.self, forKey: .isHide)
		isSurgeHours = try values.decodeIfPresent(Int.self, forKey: .isSurgeHours)
		isZone = try values.decodeIfPresent(Int.self, forKey: .isZone)
		maxSpace = try values.decodeIfPresent(Int.self, forKey: .maxSpace)
		minFare = try values.decodeIfPresent(Int.self, forKey: .minFare)
		priceForTotalTime = try values.decodeIfPresent(Double.self, forKey: .priceForTotalTime)
		priceForWaitingTime = try values.decodeIfPresent(Int.self, forKey: .priceForWaitingTime)
		pricePerUnitDistance = try values.decodeIfPresent(Double.self, forKey: .pricePerUnitDistance)
		providerMiscellaneousFee = try values.decodeIfPresent(Int.self, forKey: .providerMiscellaneousFee)
		providerProfit = try values.decodeIfPresent(Int.self, forKey: .providerProfit)
		providerTax = try values.decodeIfPresent(Int.self, forKey: .providerTax)
		surgeEndHour = try values.decodeIfPresent(Int.self, forKey: .surgeEndHour)
		
        surgeMultiplier = try values.decodeIfPresent(Double.self, forKey: .surgeMultiplier)
        richAreaSurgeMultiplier = try values.decodeIfPresent(Double.self, forKey: .richAreaSurgeMultiplier)
        
		surgeStartHour = try values.decodeIfPresent(Int.self, forKey: .surgeStartHour)
		tax = try values.decodeIfPresent(Int.self, forKey: .tax)
		totalProviderInZoneQueue = try values.decodeIfPresent([String].self, forKey: .totalProviderInZoneQueue)
		typeImage = try values.decodeIfPresent(String.self, forKey: .typeImage)
		typename = try values.decodeIfPresent(String.self, forKey: .typename)
		updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
		userMiscellaneousFee = try values.decodeIfPresent(Int.self, forKey: .userMiscellaneousFee)
		userTax = try values.decodeIfPresent(Int.self, forKey: .userTax)
		waitingTimeStartAfterMinute = try values.decodeIfPresent(Int.self, forKey: .waitingTimeStartAfterMinute)
		zoneIds = try values.decodeIfPresent([String].self, forKey: .zoneIds)
	}


}
