//
//	Citytype.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct Citytype : Codable {

	var  v : Int = 0
	var  id : String = ""
	var  basePrice : Double = 0.0
	var  basePriceDistance : Double = 0.0
	var  cancellationFee : Double = 0.0
	var  carRentalIds : [String] = []
	var  cityid : String = ""
	var  cityname : String = ""
	var  countryid : String = ""
	var  countryname : String = ""
	var  createdAt : String = ""
	var  isBuiesness : Int = 0
	var  isCarRentalBusiness : Int = 0
	var  isHide : Int = 0
	var  isSurgeHours : Int = 0
	var  isZone : Int = 0
	var  maxSpace : Int = 0
	var  minFare : Double = 0.0
	var  priceForTotalTime : Double = 0.0
	var  priceForWaitingTime : Double = 0.0
	var  pricePerUnitDistance : Double = 0.0
	var  providerMiscellaneousFee : Double = 0.0
	var  providerProfit : Double = 0.0
	var  providerTax : Double = 0.0
	var  surgeEndHour : Int = 0
    var  surgeHours : [SurgeHour] = []
	var  surgeMultiplier : Double = 0.0
    var  richAreaSurgeMultiplier : Double = 0.0
	var  surgeStartHour : Int = 0
	var  tax : Double = 0.0
	var  totalProviderInZoneQueue : [TotalProviderInZoneQueue] = []
	var  typeDetails : TypeDetail = TypeDetail.init()
	var  typeid : String  = ""
	var  updatedAt : String  = ""
	var  userMiscellaneousFee : Double  = 0.0
	var  userTax : Double  = 0.0
	var  waitingTimeStartAfterMinute : Int = 0
	var  zoneIds : [String] = []
	var  zoneMultiplier : Double = 0.0


	enum CodingKeys: String, CodingKey {
		case v = "__v"
		case id = "_id"
		case basePrice = "base_price"
		case basePriceDistance = "base_price_distance"
		case cancellationFee = "cancellation_fee"
		case carRentalIds = "car_rental_ids"
		
		case cityid = "cityid"
		case cityname = "cityname"
		case countryid = "countryid"
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
		case surgeHours = "surge_hours"
		case surgeMultiplier = "surge_multiplier"
		case surgeStartHour = "surge_start_hour"
		case tax = "tax"
		case totalProviderInZoneQueue = "total_provider_in_zone_queue"
		case typeDetails = "type_details"
		case typeid = "typeid"
		case updatedAt = "updated_at"
		case userMiscellaneousFee = "user_miscellaneous_fee"
		case userTax = "user_tax"
		case waitingTimeStartAfterMinute = "waiting_time_start_after_minute"
		case zoneIds = "zone_ids"
		case zoneMultiplier = "zone_multiplier"
        case richAreaSurgeMultiplier = "rich_area_surge_multiplier"
	}
	init(from decoder: Decoder) throws {
		let  values = try decoder.container(keyedBy: CodingKeys.self)
        v = try values.decodeIfPresent(Int.self, forKey: .v) ?? 0
		id = try values.decodeIfPresent(String.self, forKey: .id) ?? ""
		basePrice = try values.decodeIfPresent(Double.self, forKey: .basePrice) ?? 0.0
		basePriceDistance = try values.decodeIfPresent(Double.self, forKey: .basePriceDistance) ?? 0.0
		cancellationFee = try values.decodeIfPresent(Double.self, forKey: .cancellationFee) ?? 0.0
		carRentalIds = try values.decodeIfPresent([String].self, forKey: .carRentalIds) ?? []
	
		cityid = try values.decodeIfPresent(String.self, forKey: .cityid) ?? ""
		cityname = try values.decodeIfPresent(String.self, forKey: .cityname) ?? ""
		countryid = try values.decodeIfPresent(String.self, forKey: .countryid) ?? ""
		countryname = try values.decodeIfPresent(String.self, forKey: .countryname) ?? ""
		createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt) ?? ""
		isBuiesness = try values.decodeIfPresent(Int.self, forKey: .isBuiesness) ?? 0
		isCarRentalBusiness = try values.decodeIfPresent(Int.self, forKey: .isCarRentalBusiness) ?? 0
		isHide = try values.decodeIfPresent(Int.self, forKey: .isHide) ?? 0
		isSurgeHours = try values.decodeIfPresent(Int.self, forKey: .isSurgeHours) ?? 0
		isZone = try values.decodeIfPresent(Int.self, forKey: .isZone) ?? 0
		maxSpace = try values.decodeIfPresent(Int.self, forKey: .maxSpace) ?? 0
		minFare = try values.decodeIfPresent(Double.self, forKey: .minFare) ?? 0.0
		priceForTotalTime = try values.decodeIfPresent(Double.self, forKey: .priceForTotalTime) ?? 0.0
		priceForWaitingTime = try values.decodeIfPresent(Double.self, forKey: .priceForWaitingTime) ?? 0.0
		pricePerUnitDistance = try values.decodeIfPresent(Double.self, forKey: .pricePerUnitDistance) ?? 0.0
		providerMiscellaneousFee = try values.decodeIfPresent(Double.self, forKey: .providerMiscellaneousFee) ?? 0.0
		providerProfit = try values.decodeIfPresent(Double.self, forKey: .providerProfit) ?? 0.0
		providerTax = try values.decodeIfPresent(Double.self, forKey: .providerTax) ?? 0.0
		surgeEndHour = try values.decodeIfPresent(Int.self, forKey: .surgeEndHour) ?? 0
		surgeHours = try values.decodeIfPresent([SurgeHour].self, forKey: .surgeHours) ?? []
		surgeMultiplier = try values.decodeIfPresent(Double.self, forKey: .surgeMultiplier) ?? 0.0
		surgeStartHour = try values.decodeIfPresent(Int.self, forKey: .surgeStartHour) ?? 0
		tax = try values.decodeIfPresent(Double.self, forKey: .tax) ?? 0.0
		totalProviderInZoneQueue = try values.decodeIfPresent([TotalProviderInZoneQueue].self, forKey: .totalProviderInZoneQueue) ?? []
		typeDetails = try values.decodeIfPresent(TypeDetail.self, forKey: .typeDetails) ?? TypeDetail.init()
		typeid = try values.decodeIfPresent(String.self, forKey: .typeid) ?? ""
		updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt) ?? ""
		userMiscellaneousFee = try values.decodeIfPresent(Double.self, forKey: .userMiscellaneousFee) ?? 0.0
		userTax = try values.decodeIfPresent(Double.self, forKey: .userTax) ?? 0.0
		waitingTimeStartAfterMinute = try values.decodeIfPresent(Int.self, forKey: .waitingTimeStartAfterMinute) ?? 0
		zoneIds = try values.decodeIfPresent([String].self, forKey: .zoneIds) ?? []
		zoneMultiplier = try values.decodeIfPresent(Double.self, forKey: .zoneMultiplier) ?? 0.0
        richAreaSurgeMultiplier =  try values.decodeIfPresent(Double.self, forKey: .richAreaSurgeMultiplier) ?? 0.0
	}
    
    init() {}
}

struct TotalProviderInZoneQueue : Codable {
    var  zone_queue_id : String = ""
    var total_provider_in_zone_queue: Int = 0
    
    enum CodingKeys: String, CodingKey {
        case zone_queue_id = "zone_queue_id"
        case total_provider_in_zone_queue = "total_provider_in_zone_queue"
    }
    
    init(from decoder: Decoder) throws {
        let  values = try decoder.container(keyedBy: CodingKeys.self)
        zone_queue_id = try values.decodeIfPresent(String.self, forKey: .zone_queue_id) ?? ""
        total_provider_in_zone_queue = try values.decodeIfPresent(Int.self, forKey: .total_provider_in_zone_queue) ?? 0
    }
}
